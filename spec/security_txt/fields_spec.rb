# frozen_string_literal: true

require "time"

RSpec.describe SecurityTxt::Fields do
  subject(:fields) do
    described_class.new(
      acknowledgments: acknowledgments,
      canonical: canonical,
      contact: contact,
      encryption: encryption,
      expires: expires
    )
  end

  let(:acknowledgments) { ["https://www.example.com/security/thanks"] }
  let(:canonical) { ["https://www.example.com/.well-known/security.txt", "https://blah.com/.well-known/security.txt"] }
  let(:contact) { ["mailto:security@example.com", "tel:+14015551234", "https://example.com/contact"] }
  let(:encryption) { ["https://www.example.com/pgpkey", "dns:blerp._openpgpkey.example.com"] }
  let(:expires) { Time.now + (60 * 60 * 24 * 5) }

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
  end

  describe "#contact=" do
    it "raises if any scheme is invalid" do
      expect do
        fields.contact = ["https://example.com", "http://example.com"]
      end.to raise_error(ArgumentError)
    end
  end

  describe "#encryption=" do
    it "raises if any scheme is invalid" do
      expect do
        fields.encryption = ["https://example.com", "http://example.com"]
      end.to raise_error(ArgumentError)
    end
  end

  describe "#expires=" do
    it "raises if invalid" do
      expect { fields.expires = "blah" }.to raise_error(ArgumentError)
    end

    it "accepts ISO8601 strings" do
      expect { fields.expires = "2022-01-01T12:34:56.0123Z" }.not_to raise_error
    end

    it "accepts Time objects" do
      expect { fields.expires = Time.now }.not_to raise_error
    end
  end

  describe "#valid?" do
    subject(:valid?) { fields.valid? }

    context "when Expires is unset" do
      let(:expires) { nil }

      it { is_expected.to be(false) }
    end

    context "when Contact is empty" do
      let(:contact) { [] }

      it { is_expected.to be(false) }
    end

    context "when Contact is unset" do
      let(:contact) { nil }

      it { is_expected.to be(false) }
    end
  end

  describe "#to_h" do
    subject(:hash) { fields.to_h }

    it "excludes blank fields" do
      fields.acknowledgments = nil
      expect(hash).to exclude("Acknowledgments")
    end

    it do
      is_expected.to include(
        "Acknowledgments" => acknowledgments,
        "Canonical" => canonical,
        "Contact" => contact,
        "Encryption" => encryption
      )
    end
  end

  describe "#to_s" do
    subject(:string) { fields.to_s }

    it "excludes blank fields" do
      fields.acknowledgments = nil
      expect(string).to exclude("Acknowledgments")
    end

    it "works" do
      expect(string).to eq(<<~STR.chomp
        Acknowledgments: #{acknowledgments[0]}

        Canonical: #{canonical[0]}

        Canonical: #{canonical[1]}

        Contact: #{contact[0]}

        Contact: #{contact[1]}

        Contact: #{contact[2]}

        Encryption: #{encryption[0]}

        Encryption: #{encryption[1]}

        Expires: #{expires.iso8601}
      STR
                          )
    end
  end
end
