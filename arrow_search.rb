#!/usr/bin/env ruby

require 'json'

# Space separated keywords in Alfred is passed as a single argument
queries = ARGV.empty? ? ARGV : ARGV[0].split(' ')

arrows = [
	{ keywords: "top", char: "↑" },
	{ keywords: "top right", char: "↗" },
	{ keywords: "right", char: "→" },
	{ keywords: "bottom right", char: "↘" },
	{ keywords: "bottom", char: "↓" },
	{ keywords: "bottom left", char: "↙" },
	{ keywords: "left", char: "←" },
	{ keywords: "top left", char: "↖" },
]

def search_arrows(arrows, queries)
	if queries.empty?
		arrows
	else
		queries.reduce(arrows) do |acc, q|
			acc.filter { |arrow| arrow[:keywords].include?(q) }
		end
	end
end

def generate_alfred_json(entries)
	results = entries.map do |el|
		{
			title: el[:char],
			subtitle: "#{el[:keywords]} · Enter to copy... #{el[:char]}",
			arg: el[:char],
			valid: true
		}
	end

	results = [{
		title: "No arrows found",
		subtitle: "Try searching top, left,...",
		valid: false
	}] if results.empty?

	{items: results}
end

results = search_arrows(arrows, queries)
alfred_json = generate_alfred_json(results)
print JSON.pretty_generate(alfred_json)
