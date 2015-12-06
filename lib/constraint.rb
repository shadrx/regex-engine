# The result of a constraint match.
class Match
  attr_reader :text

  # Creates a unmatched result.
  def self.unmatched
    Match.new([])
  end

  # Creates a new match result.
  def initialize(matched_text)
    @text = matched_text
  end
end

class Constraint
  # Attempts to match a constraint with a value.
  # Returns a list of match results
  def matches(value)
    fail 'Constraint#match is not implemented'
  end
end

module Constraints
  # Checks that a set of characters are equal to a value.
  # Regex: /foo/
  class Eq < Constraint
    def initialize(text)
      @text = text
    end

    def matches(text)
      if @text == text
        [Match.new(text)]
      else
        []
      end
    end
  end

  # Regex: /(abc|def)/
  class Or < Constraint
    def initialize(constraints)
      @constraints = constraints
    end

    def matches(value)
      @constraints.flat_map { |constraint| constraint.matches(value) }
    end
  end

  # Regex: /./
  class AnyCharacter < Constraint
    def initialize; end
  end

  # Regex: /abc+/
  # Matches at least one `abc` token.
  class RepeatOneOrMore < Constraint
    def initialize(constraint)
      @constraint = constraint
    end

    def matches(value)
    end
  end

  # Regex: /abc*/
  # Matches 0 or more `abc` tokens.
  class RepeatAnyAmount < Constraint
    def initialize(constraint)
      @constraint = constraint
    end

    def matches(value)
    end
  end

  # Regex: /abc{2,3}/
  # Matches `abc` at least twice and at most three times.
  class RepeatExactTimes < Constraint
    def initialize(constraint, min, max)
      @constraint = constraint
      @min = min
      @max = max
    end

    def matches(value)
    end
  end
end


