require 'byebug'
require_relative 'constraints'

class Tokenizer

  SPECIAL_TOKENS = ["/", ".", "+", "[", "]", "(", ")"]

  def initialize(input)
    @input = input
    @processed_character_count = 0
  end

  def tokenize
    tokens = []
    while remaining_input?
      if special_token?(peek)
       tokens << next_symbol 
      else 
       tokens << next_word
      end
    end

    tokens
  end

  private

  def peek
    remaining_input.first
  end

  def next_symbol
    character = peek
    @processed_character_count += 1
    character
  end

  def next_word
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
