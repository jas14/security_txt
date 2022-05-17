# frozen_string_literal: true

require "time"
require_relative "configurable"

module SecurityTxt
  # Object representing all security.txt fields.
  # Provides getters, setters with limited validation, and string generation.
  class Fields
    extend Configurable

    CONTACT_PREFIXES = ["https://", "mailto:", "tel:"].freeze
    NOT_PROVIDED = Object.new.freeze

    # rubocop:disable Metrics/ParameterLists
    def initialize(acknowledgments: nil, canonical: nil, contact: nil, encryption: nil, expires: nil,
                   hiring: nil, preferred_languages: nil)
      self.acknowledgments = acknowledgments
      self.canonical = canonical
      self.contact = contact
      self.encryption = encryption
      self.expires = expires
      self.hiring = hiring
      self.preferred_languages = preferred_languages
    end
    # rubocop:enable Metrics/ParameterLists

    # Get or set security.txt fields. Always returns `self`.
    #
    # If not given a block, just returns self:
    #
    #   SecurityTxt::Fields.new.configure # => #<SecurityTxt::Fields:...>
    #
    # If given a block with no parameters, evaluates the block on the Fields instance:
    #
    #   SecurityTxt::Fields.new.configure do
    #     acknowledgments "https://www.example.com/thanks"
    #     canonical       "https://www.example.com/.well-known/security.txt"
    #   end
    #
    # If given a block with 1 or more parameters, yields Fields to the block:
    #
    #   SecurityTxt::Fields.new.configure do |fields|
    #     fields.acknowledgments = "https://www.example.com/thanks"
    #     fields.canonical       = "https://www.example.com/.well-known/security.txt"
    #   end
    def configure(&block)
      block_params = block&.parameters

      unless block_params.nil?
        if block_params.empty?
          instance_eval(&block)
        else
          block.call self
        end
      end

      self
    end

    # optional Array<String>
    # URI indicating the Acknowledgments page; see https://www.rfc-editor.org/rfc/rfc9116#name-acknowledgments
    field :acknowledgments do |val|
      if val
        val = Array(val)
        unless val.all? { |uri| uri.start_with?("https://") }
          raise ArgumentError, "acknowledgments must all be HTTPS URIs"
        end
      end

      val
    end

    # optional Array<String>
    # URIs indicating where security.txt is located; see https://www.rfc-editor.org/rfc/rfc9116#name-canonical
    field :canonical do |val|
      if val
        val = Array(val)
        raise ArgumentError, "canonicals must all be HTTPS URIs" unless val.all? { |uri| uri.start_with?("https://") }
      end

      val
    end

    # required Array<String>
    # URIs indicating where security.txt is located; see https://www.rfc-editor.org/rfc/rfc9116#name-canonical
    field :contact do |val|
      if val
        val = Array(val)
        unless val.all? { |uri| CONTACT_PREFIXES.any? { |prefix| uri.start_with?(prefix) } }
          raise ArgumentError, "contacts must all be mailto, tel, or HTTPS URIs"
        end
      end

      val
    end

    # optional Array<String>
    # URI(s) pointing to location where PGP encryption key is located; see https://www.rfc-editor.org/rfc/rfc9116.html#name-encryption
    field :encryption do |val|
      if val
        val = Array(val)

        if val.any? { |uri| uri.start_with?("http://") }
          raise ArgumentError, "encryptions must not use plain HTTP schemes"
        end
      end

      val
    end

    # required String|#iso8601
    # ISO8601 string or Object responding to #iso8601 indicating the date and time after which this security.txt data
    # should not be used; see https://www.rfc-editor.org/rfc/rfc9116.html#name-expires
    field :expires do |val|
      if val.is_a?(String)
        val = Time.iso8601(val)
      elsif !val.respond_to?(:iso8601) && !val.nil?
        raise ArgumentError, "expires must be a String or respond to #iso8601"
      end

      val
    end

    # optional Array<String>
    # URI(s) pointing to information about security-related job positions; see https://www.rfc-editor.org/rfc/rfc9116.html#name-hiring
    field :hiring do |val|
      raise ArgumentError, "hirings must not use plain HTTP schemes" if val&.any? { |uri| uri.start_with?("http://") }

      val
    end

    # optional Array<String>
    # Locale code(s) indicating the preferred natural language(s) for security reports; see https://www.rfc-editor.org/rfc/rfc9116.html#name-preferred-languages
    field :preferred_languages do |val|
      Array(val) if val
    end

    def valid?
      !expires.nil? && contact.is_a?(Array) && !contact.empty?
    end

    def to_h
      {
        "Acknowledgments" => acknowledgments,
        "Canonical" => canonical,
        "Contact" => contact,
        "Encryption" => encryption,
        "Expires" => expires&.iso8601,
        "Hiring" => hiring,
        "Preferred-Languages" => preferred_languages&.join(", "),
      }.compact
    end

    def to_s
      to_h.compact.flat_map do |field_name, field_value|
        field_values = Array(field_value)
        field_values.map { |v| "#{field_name}: #{v}" }.join("\n")
      end.join("\n\n")
    end
  end
end
