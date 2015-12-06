# The result of a constraint match.
class MatchResult
  attr_reader :text

  # Creates a unmatched result.
  def self.unmatched
    MatchResult.new([])
  end

  # Creates a new match result.
  # If `characters` is empty, then no matches were made.
  def initialize(matched_text)
    @text = matched_text
  end

  def matched?
    !@text..empty?
  end
end

class Constraint
  def match(value)
    fail 'Constraint#match is not implemented'
  end
end

module Constraints
  # Checks that a set of characters are equal to a value.
  # Regex: /foo/
  class Eq < Constraint
    def initialize(value)
      @value = value
    end

    def match(value)
    end
  end

  # Regex: /(abc|def)/
  class Or < Constraint
    def initialize(constraints)
      @constraints = constraints
    end

    def match(value)
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

    def match(value)
    end
  end

  # Regex: /abc*/
  # Matches 0 or more `abc` tokens.
  class RepeatAnyAmount < Constraint
    def initialize(constraint)
      @constraint = constraint
    end

    def match(value)
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

    def match(value)
    end
  end
end


