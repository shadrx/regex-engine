require_relative '../lib/constraint'

describe Match do
  describe "#merge" do
    context "when merging two overlapping matches" do
      let(:merged) {
        Match.new(10, 20).merge(Match.new(15, 30))
      }

      it "combines the ranges" do
        expect(merged).to eq Match.new(10, 30)
      end
    end

    context "when merging two disjoint matches" do
      subject {
        -> {Match.new(10, 20).merge(Match.new(21, 30)) }
      }

      it { is_expected.to raise_error Exception }
    end
  end

  describe ".merge_matches" do
    context "when merging two disjount matches" do
      let(:matches) {[
        Match.new(10, 20),
        Match.new(21, 30),
      ]}

      let(:merged) { Match.merge_matches(matches) }

      it "should give two disjoint matches" do
        expect(merged.length).to eq 2
      end

      it "should not modify the first range" do
        expect(merged[0]).to eq Match.new(10, 20)
      end

      it "should not modify the second range" do
        expect(merged[1]).to eq Match.new(21, 30)
      end
    end

    context "when merging two overlapping matches" do
      let(:matches) {[
        Match.new(10, 20),
        Match.new(15, 30),
      ]}

      let(:merged) { Match.merge_matches(matches) }

      it "should give one merged match" do
        expect(merged.length).to eq 1
      end

      it "should combine the match ranges" do
        expect(merged.first).to eq Match.new(10, 30)
      end
    end
  end
end

describe Constraint do

end
