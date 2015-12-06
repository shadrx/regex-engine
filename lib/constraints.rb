require_relative 'constraint'

module Constraints
  # Checks that a set of characters are equal to a value.
  # Regex: /foo/
  class Eq < Constraint
    def initialize(text)
      @text = text
    end

    def matches(text)
      if @text == text
        [Match.new(0, text.length)]
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

    def matches(text)
      @constraints.flat_map { |constraint| constraint.matches(text) }
    end
  end

  # Regex: /./
  class AnyCharacter < Constraint
    def initialize; end

    # FIXME: this probably doesn't handle new lines properly.
    def matches(text)
      # Match every character
      (0...text.length).map do |index|
          Match.new(index, index+1)
      end
    end
  end

  # Regex: /abc+/
  # Matches at least one `abc` token.
  class RepeatOneOrMore < Constraint
    def initialize(constraint)
      @constraint = constraint
    end

    def matches(text)
      fail 'unimplemented'
    end
  end

  # Regex: /abc*/
  # Matches 0 or more `abc` tokens.
  class RepeatAnyAmount < Constraint
    def initialize(constraint)
      @constraint = constraint
    end

    def matches(text)
      fail 'unimplemented'
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

    def matches(text)
      fail 'unimplemented'
    end
  end
end

