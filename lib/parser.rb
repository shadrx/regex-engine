require 'byebug'
require_relative 'constraints'

class Parser

  class ParserError < StandardError
  end

  SPECIAL_TOKENS = ["/", ".", "+", "[", "]", "(", ")"]

  def initialize(input)
    @input = input
    @processed_character_count = 0
  end

  def parse
    expect_next_to_be("/")
    Constraints::Eq.new(parse_equals)
  end

  private

  def parse_equals
    take_until_or_end { |c| SPECIAL_TOKENS.include?(c) }.join
  end

  def take_until_or_end(&block)
    chars = remaining_input.take_while { |c| !block.call(c) && remaining_input? }
    @processed_character_count += chars.length
    chars
  end

  def expect_next_to_be(character)
    if remaining_input.first != character 
      raise ParserError, "Expected '#{character}' but got '#{remaining_input.first}'"
    end

    @processed_character_count += 1
  end

  def remaining_input
    @input.chars.drop(@processed_character_count)
  end

  def remaining_input?
    @processed_character_count < @input.length
  end

  def special_token?(special_token)
    SPECIAL_TOKENS.include?(special_token)
  end

end
