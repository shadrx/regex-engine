require_relative '../lib/constraints'

describe Constraints::Eq do
  describe "#matches" do
    context "when matching an identical string" do
      let(:matches) { Constraints::Eq.new("hello").matches("hello") }

      it "has a single match" do; expect(matches.length).to eq 1; end
      it "matches every character" do; expect(matches.first.length).to eq 5; end
    end

    context "when matching a substring" do
      let(:matches) { Constraints::Eq.new("hello").matches("ll") }

      it "has no matches" do; expect(matches).to be_empty; end
    end

    context "when matching a similar string" do
      let(:matches) { Constraints::Eq.new("hello").matches("hellp") }

      it "has no matches" do; expect(matches).to be_empty; end
    end

    context "when matching a completely different string" do
      let(:matches) { Constraints::Eq.new("hello").matches("fdas") }

      it "has no matches" do; expect(matches).to be_empty; end
    end
  end
end

describe Constraints::Or do
  describe "#matches" do
    context "when matching a single equal constraint" do
      let(:constraints) {
        Constraints::Or::new([Constraints::Eq.new("hello")])
      }

      context "when the tokens are identical" do
        it "has a single match" do
          expect(constraints.matches("hello").length).to eq 1
        end
      end
    end

    # context "when matching two simple equal constraints" do
    #   let(:constraint) {
    #     Constraints::Or.new([
    #       Constraints::Eq.new("hello"),
    #       Constraints::Eq.new("world"),
    #     ])
    #   }
    #
    #   let(:matches) { constraint.matches("hello") }
    #
    #   it "has two matches" do; expect(matches.length).to eq 2; end
    # end
  end
end

describe Constraints::AnyCharacter do

end

describe Constraints::RepeatOneOrMore do

end

describe Constraints::RepeatAnyAmount do

end

describe Constraints::RepeatExactTimes do

end
