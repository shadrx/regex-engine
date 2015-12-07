require_relative '../lib/tokenizer'

describe Tokenizer do

  describe "#tokenize" do
    def tokenize(input)
      Tokenizer.new(input).tokenize
    end

    context "when reading a word" do
      subject { tokenize("abc") }

      it { is_expected.to eq ["abc"] }
    end

    context "when reading a word with a plus afterward" do
      subject { tokenize("abc+") }

      it { is_expected.to eq ["abc", "+"] }
    end
  end

end
