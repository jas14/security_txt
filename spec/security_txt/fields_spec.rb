# frozen_string_literal: true

RSpec.describe SecurityTxt::Fields do
  subject(:fields) { described_class.new(acknowledgments: acknowledgments) }

  let(:acknowledgments) { "https://www.example.com/security/thanks" }
  let(:canonical) { ["https://www.example.com/.well-known/security.txt"] }

  describe "#acknowledgments=" do
    it "raises if the scheme is invalid" do
      expect { fields.acknowledgments = "http://www.example.com" }.to raise_error(ArgumentError)
    end
  end

  describe "#canonical=" do
    it "raises if any scheme is invalid" do
      expect do
        fields.canonical = ["https://example.com", "http://example.com"]
      end.to raise_error(ArgumentError)
    end

    it "raises if not provided an array" do
      expect { fields.canonical = "hi" }.to raise_error(ArgumentError)
    end
  end

  describe "#to_h" do
    subject(:hash) { fields.to_h }

    it "excludes blank fields" do
      fields.acknowledgments = nil
      expect(hash).to exclude("Acknowledgments")
    end

    it { is_expected.to include("Acknowledgments" => acknowledgments) }
  end

  describe "#to_s" do
    subject(:string) { fields.to_s }

    it "excludes blank fields" do
      fields.acknowledgments = nil
      expect(string).to exclude("Acknowledgments")
    end

    it { is_expected.to include("Acknowledgments: #{acknowledgments}") }
  end
end
