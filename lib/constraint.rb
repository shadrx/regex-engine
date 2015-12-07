# The result of a constraint match.
class Match
  attr_reader :low_index, :high_index

  # Creates a new match result.
  def initialize(low_index, high_index)
    @low_index = low_index
    @high_index = high_index
  end

  def adjacent?(match)
    @high_index == match.low_index ||
      @low_index == match.high_index
  end

  def overlap?(match)
    @low_index <= match.high_index &&
      match.low_index <= @high_index
  end

  # Gets the number of characters that were matched.
  def length
    @high_index - @low_index
  end

  # Merges two adjacent matches.
  # Raises an `Exception` if they are not adjacent.
  def merge(match)
    raise Exception, 'matches are not overlapping' if !overlap?(match)

    low = (@low_index < match.low_index) ? @low_index : match.low_index
    high = (@high_index > match.high_index) ? @high_index : match.high_index

    Match.new(low, high)
  end

  def self.merge_matches(matches)
    results = []

    matches.each do |match|
      maybe_overlapping_index = results.find_index { |m| m.overlap?(match) }

      if maybe_overlapping_index
        maybe_overlapping = results[maybe_overlapping_index]

        # merge the old match with the current
        results[maybe_overlapping_index] = maybe_overlapping.merge(match)
      else # no overlap
        results << match
      end
    end

    results
  end

  def ==(other)
    if other.is_a?(Match)
      @low_index == other.low_index &&
        @high_index == other.high_index
    else
      false
    end
  end

  def inspect
    "(#{@low_index},#{@high_index})"
  end
end

class Constraint
  # Attempts to match a constraint with a value.
  # Returns a list of match results
  def matches(value)
    fail 'Constraint#match is not implemented'
  end
end

