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

