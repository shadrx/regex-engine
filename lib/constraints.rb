require_relative 'match'

module Constraints

  class Constraint
    # Attempts to match a constraint with a value.
    # Returns a list of match results
    def matches(value)
      fail 'Constraint#match is not implemented'
    end
  end

  # Checks that a set of characters are equal to a value.
  # Regex: /foo/
  class Eq < Constraint
    attr_reader :text

    def initialize(text)
      @text = text
    end

    def matches(text)
      text.chars.each.with_index.inject([]) do |results,char_and_index|
        char,index = char_and_index
        if char == @text.chars.first
          substr = text[index..-1]

          if substr.start_with?(@text)
            results += [Match.new(index, index+@text.length)]
          end
        end

        results
      end
    end

    def to_s
      @text
    end

    def ==(other)
      if other.is_a?(Eq)
        @text == other.text
      else
        @text == other
      end
    end
  end

  # No corresponding regex.
  class And < Constraint
    attr_reader :constraints

    def initialize(constraints)
      @constraints = constraints
    end

    def matches(text)
      # find every single match for the constraint
      all_matches = @constraints.each.flat_map do |constraint|
        matches = constraint.matches(text)

        if matches.empty?
          return []
        end

        matches
      end

      # we only correctly match if all matches are
      # adjacent to each other.
      all_matches.each.inject do |prev,cur|
        if !prev.adjacent?(cur)
          return []
        end
        cur
      end

      all_matches
    end

    def ==(other)
      if other.is_a?(And)
        @constraints == other.constraints
      else
        false
      end
    end

    def to_s
      @constraints.join
    end
  end

  # Regex: /(abc|def)/
  class Or < Constraint
    attr_reader :constraints

    def initialize(constraints)
      @constraints = constraints
    end

    def matches(text)
      @constraints.flat_map { |constraint| constraint.matches(text) }
    end

    def ==(other)
      if other.is_a?(Or)
        @constraints == other.constraints
      else
        false
      end
    end

    def to_s
      is_first = true
      @constraints.map(&:to_s).inject("(") do |str,constraint_str|
        if is_first
          is_first = false
        else
          str += "|"
        end

        str + constraint_str
      end
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

    def ==(other)
      if other.is_a?(AnyCharacter)
        true
      else
        false
      end
    end

    def to_s
      "."
    end
  end

  # A generic repeat constraint.
  class Repeat < Constraint
    attr_reader :constraint, :range

    # The maximum number of repetitions
    # Used because we don't have infinite ranges.
    MAX_REPETITIONS = 100000000

    # Regex: /abc*/
    # Matches 0 or more `abc` tokens.
    def self.any_number(constraint)
      Repeat.new(constraint, (0..MAX_REPETITIONS))
    end

    # Regex: /abc+/
    # Matches at least one `abc` token.
    def self.at_least_once(constraint)
      Repeat.new(constraint, (1..MAX_REPETITIONS))
    end

    # Regex: /abc{2,3}/
    # Repeats a constraint between `min_times` and `max_times`.
    def self.between(constraint, min_times, max_times)
      Repeat.new(constraint, (min_times..max_times))
    end

    # Repeats a constraint exactly `n` times.
    def self.exactly(constraint, n)
      Repeat.new(constraint, (n..n))
    end

    def initialize(constraint, range)
      @constraint = constraint
      @range = range
    end

    def matches(text)
      matches = @constraint.matches(text)

      if @range.include?(matches.length)
        matches
      else
        []
      end
    end

    def ==(other)
      if other.is_a?(Repeat)
        @constraint == other.constraint &&
          @range == other.range
      end
    end

    def to_s
      if @range == (0..MAX_REPETITIONS)
        "#{@constraint}*"
      elsif @range == (1..MAX_REPETITIONS)
        "#{@constraint}+"
      else
        "#{constraint}{{#{@range.first},#{@range.last}}}"
      end
    end
  end
end

