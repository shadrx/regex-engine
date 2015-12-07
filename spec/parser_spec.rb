require_relative '../lib/parser'

RSpec.describe Parser do
  describe "#parse" do
    it "returns equals contraint up until special character" do
      parser = Parser.new("/test./")
      expect(parser.parse).to eq Constraints::Eq.new("test")
    end

    it "raises ParserError if first character is not '/'" do
      parser = Parser.new("test")
      expect { parser.parse }.to raise_error(Parser::ParserError, "Expected '/' but got 't'")
    end
  end
    
end
