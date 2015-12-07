require_relative 'constraints'

class Parser

  def initialize(tokens)
    @tokens = tokens
    @position = 0
  end

  def parse
    first_token = self.peek_token

    expect { |t| t=="/" }

    root_constraints = []
    
    while !finished?
      if first_token == "["
        root_constraints << parse_character_class
      elsif first_token == "."
        root_contraints << parse_any_period
      else
        root_constraints << parse_eq
      end
    end

    Constraints::And.new(root_constraints)
  end

  def parse_character_class
    fail
  end

  def parse_any_period
    fail
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

  def expect(&predicate)
    next_tok = next_token
    if !predicate.call(next_tok)
      raise "expected not that"
    end
  end

  def remaining?
    @position <= @tokens.length
  end
end
