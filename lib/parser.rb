require_relative 'constraints'

class Parser

  START_END_TOKEN = "/"

  class ParserError < StandardError
  end

  def initialize(tokens)
    @tokens = tokens
    @position = 0
  end

  def parse

    expect_next_to_be(START_END_TOKEN)


    root_constraints = []

    while !finished?
      first_token = peek_token

      if first_token == "["
        constraint = parse_character_class
      elsif first_token == "."
        constraint = parse_any_character
      else
        constraint = parse_eq
      end

      case peek_token
      when "+"
        byebug
        constraint = parse_one_or_more(constraint)
      end

      root_constraints << constraint
    end

    Constraints::And.new(root_constraints)
  end

  def parse_character_class 
    fail
  end

  def parse_any_character
    eat
    Constraints::AnyCharacter.new
  end

  def parse_one_or_more(constraint)
    expect_next_to_be("+")
    Constraints::Repeat.at_least_once(constraint)
  end

  def parse_eq
    Constraints::Eq.new(next_token)
  end

  def peek_token
    @tokens[@position]
  end

  def eat
    @position += 1
  end

  def next_token
    c = peek_token
    eat
    c
  end

  def finished?
    peek_token == "/"
  end

  def expect_next_to_be(token)
    if peek_token != token 
      raise ParserError, "Expected '#{token}' but got '#{@tokens.first}'"
    end

    eat
  end

  def remaining?
    @position <= @tokens.length
  end
end
