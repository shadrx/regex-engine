#! /usr/bin/env ruby

require_relative '../lib/parser'
require_relative '../lib/tokenizer'

print "Enter a regex: "
REGEX = gets.chomp

parser = Parser.new(Tokenizer.new(REGEX).tokenize)
root_constraint = parser.parse
puts "Parsed regex: /#{root_constraint}/"

puts
print "Enter text to search: "
TEXT = gets.chomp

puts "text: '#{TEXT}'"
matches = root_constraint.matches(TEXT)

puts "Match indices: #{matches}"

substrings = matches.map do |match|
  TEXT[match.low_index..match.high_index-1]
end

puts
substrings.each do |substring|
  puts "Matched substring: #{substring}"
end

