# frozen_string_literal: true

require "spec_helper"

RSpec.describe SecurityTxt::Fields do
  subject(:fields) { described_class.new }

  describe "#configure" do
    context "with no block" do
      it "returns self" do
        expect(fields.configure).to eq(fields)
      end
    end

    context "with a zero-arity block" do
      subject(:configure) do
        fields.configure do
          acknowledgments "https://www.example.org/acks"
          canonical("https://www.example.com/.well-known/security.txt")
        end
      end

      it { is_expected.to eq(fields) }

      it "sets fields" do
        expect(configure).to have_attributes(
          acknowledgments: contain_exactly("https://www.example.org/acks"),
          canonical: contain_exactly("https://www.example.com/.well-known/security.txt")
        )
      end
    end

    context "with a nonzero-arity block" do
      subject(:configure) do
        fields.configure do |fields|
          fields.acknowledgments "https://www.example.org/acks"
          fields.canonical("https://www.example.com/.well-known/security.txt")
          fields.expires = Time.now
        end
      end

      it { is_expected.to eq(fields) }

      it "sets fields" do
        expect(configure).to have_attributes(
          acknowledgments: contain_exactly("https://www.example.org/acks"),
          canonical: contain_exactly("https://www.example.com/.well-known/security.txt"),
          expires: kind_of(Time)
        )
      end
    end
  end
end
