#! /usr/bin/env ruby

require_relative '../lib/parser'
require_relative '../lib/tokenizer'

REGEX = "/abc/"

parser = Parser.new(Tokenizer.new(REGEX).tokenize)
puts "/#{parser.parse}/"



