# The result of a constraint match.
class Match
  attr_reader :low_index, :high_index

  # Creates a new match result.
  def initialize(low_index, high_index)
    @low_index = low_index
    @high_index = high_index
  end

  # Gets the number of characters that were matched.
  def length
    @high_index - @low_index
  end
end

class Constraint
  # Attempts to match a constraint with a value.
  # Returns a list of match results
  def matches(value)
    fail 'Constraint#match is not implemented'
  end
end

