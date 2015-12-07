require_relative '../lib/constraints'

describe Constraints::Eq do
  describe "#matches" do
    context "when matching an identical string" do
      let(:matches) { Constraints::Eq.new("hello").matches("hello") }

      it "has a single match" do; expect(matches.length).to eq 1; end
      it "matches every character" do; expect(matches.first.length).to eq 5; end
    end

    context "when matching a substring" do
      let(:matches) { Constraints::Eq.new("ll").matches("hello") }

      it "has one match" do; expect(matches.length).to eq 1; end
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

describe Constraints::And do
  describe "#matches" do
    context "when matching a single equal constraint" do
      let(:constraints) {
        Constraints::And.new([Constraints::Eq.new("hello")])
      }

      context "when matching with an identical string" do
        let(:matches) { constraints.matches("hello") }

        it "has a single match" do; expect(matches.length).to eq 1; end
      end

      context "when matching with an incorrect string" do
        let(:matches) { constraints.matches("he") }

        it "has no matches" do; expect(matches).to be_empty; end
      end
    end

    context "when matching with two equal constraints" do
      let(:constraints) {
        Constraints::And.new([
          Constraints::Eq.new("hello"),
          Constraints::Eq.new("world"),
        ])
      }

      context "when matching with no strings correct" do
        let(:matches) { constraints.matches("abcdef") }

        it "has no matches" do; expect(matches).to be_empty; end
      end

      context "when matching with a single correct string" do
        let(:matches) { constraints.matches("world") }

        it "has no matches" do; expect(matches).to be_empty; end
      end

      context "when matching with both strings correct and adjacent" do
        let(:matches) { constraints.matches("helloworld") }

        it "has two matches" do; expect(matches.length).to eq 2; end
      end

      context "when matching with both strings correct but not adjacent" do
        let(:matches) { constraints.matches("hello world") }

        it "has no matches" do; expect(matches).to be_empty; end
      end
    end
  end
end

describe Constraints::Or do
  describe "#matches" do
    context "when matching a single equal constraint" do
      let(:constraints) {
        Constraints::Or.new([Constraints::Eq.new("hello")])
      }

      context "when the tokens are identical" do
        it "has a single match" do
          expect(constraints.matches("hello").length).to eq 1
        end
      end
    end

    context "when matching two simple equal constraints" do
      let(:constraint) {
        Constraints::Or.new([
          Constraints::Eq.new("hello"),
          Constraints::Eq.new("world"),
        ])
      }

      let(:matches) { constraint.matches("hello world") }

      it "has two matches" do; expect(matches.length).to eq 2; end
    end
  end
end

describe Constraints::AnyCharacter do
  let(:constraint) { Constraints::AnyCharacter.new }

  describe "#matches" do
    context "when matching against a simple character" do
      it "matches against 'a'" do
        expect(constraint.matches("a").length).to eq 1
      end

      it "matches against '&'" do
        expect(constraint.matches("&").length).to eq 1
      end

      it "matches against an empty space" do
        expect(constraint.matches(" ").length).to eq 1
      end
    end

    context "when matching against a string" do
      context "when matching against 'hello'" do
        let(:matches) { constraint.matches("hello") }

        it "has five matches" do; expect(matches.length).to eq 5; end
      end
    end
  end
end

describe Constraints::Repeat do
  describe "#matches" do
    context "when matching any number of repetitions" do
      let(:constraint) {
        Constraints::Repeat.any_number(Constraints::Eq.new("a"))
      }

      it "matches 5 repetitions" do
        expect(constraint.matches("aaaaa").length).to eq 5
      end

      it "matches 1 repetition" do
        expect(constraint.matches("a").length).to eq 1
      end

      it "doesn't match an incorrect string" do
        expect(constraint.matches("b")).to be_empty
      end

      context "when matching against two disjoint tokens" do
        let(:matches) { constraint.matches("aaabaaaa") }

        it "has 7 matches" do
          expect(matches.length).to be 7
        end
      end

    end

    context "when matching at least one repetition" do
      let(:constraint) {
        Constraints::Repeat.at_least_once(Constraints::Eq.new("a"))
      }

      it "doesn't match 0 repetitions" do
        expect(constraint.matches("")).to be_empty
      end

      it "matches 1 repetition" do
        expect(constraint.matches("a").length).to be 1
      end

      it "matches 12 repetitions" do
        expect(constraint.matches("aaaaaaaaaaaa").length).to eq 12
      end
    end

    context "when matching between two and four repetitions" do
      let(:constraint) {
        Constraints::Repeat.between(Constraints::Eq.new("a"), 2, 4)
      }

      it "doesn't match one repetition" do
        expect(constraint.matches("a")).to be_empty
      end

      it "matches two repetitions" do
        expect(constraint.matches("aa").length).to eq 2
      end

      it "matches three repetitions" do
        expect(constraint.matches("aaa").length).to eq 3
      end

      it "matches four repetitions" do
        expect(constraint.matches("aaaa").length).to eq 4
      end

      it "doesn't match five repetitions" do
        expect(constraint.matches("aaaaa")).to be_empty
      end
    end

    context "when matching exactly four repetitions" do
      let(:constraint) {
        Constraints::Repeat.exactly(Constraints::Eq.new("a"), 4)
      }

      it "doesn't match three repetitions" do
        expect(constraint.matches("aaa")).to be_empty
      end

      it "matches four repetitions" do
        expect(constraint.matches("aaaa").length).to eq 4
      end

      it "doesn't match five repetitions" do
        expect(constraint.matches("aaaaa")).to be_empty
      end
    end
  end
end

