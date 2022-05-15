# frozen_string_literal: true

require "spec_helper"

RSpec.describe SecurityTxt::Config do
  subject(:config) { described_class.new }

  describe "#fields" do
    context "with no block" do
      it "lazily creates fields" do
        first_return = config.fields
        expect(first_return).to be_a(SecurityTxt::Fields)

        expect(config.fields).to eq(first_return)
      end
    end

    context "with a zero-arity block" do
      subject(:fields) do
        config.fields do
          acknowledgments "https://www.example.org/acks"
          canonical("https://www.example.com/.well-known/security.txt")
        end
      end

      it { is_expected.to be_a(SecurityTxt::Fields) }

      it "sets fields" do
        expect(fields).to have_attributes(
          acknowledgments: contain_exactly("https://www.example.org/acks"),
          canonical: contain_exactly("https://www.example.com/.well-known/security.txt")
        )
      end
    end

    context "with a nonzero-arity block" do
      subject(:fields) do
        config.fields do |fields|
          fields.acknowledgments "https://www.example.org/acks"
          fields.canonical("https://www.example.com/.well-known/security.txt")
          fields.expires = Time.now
        end
      end

      it { is_expected.to be_a(SecurityTxt::Fields) }

      it "sets fields" do
        expect(fields).to have_attributes(
          acknowledgments: contain_exactly("https://www.example.org/acks"),
          canonical: contain_exactly("https://www.example.com/.well-known/security.txt"),
          expires: kind_of(Time)
        )
      end
    end
  end
end
