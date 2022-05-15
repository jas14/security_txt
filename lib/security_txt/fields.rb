# frozen_string_literal: true

require "time"

module SecurityTxt
  class Fields
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

    # optional Array<String>
    # URI indicating the Acknowledgments page; see https://www.rfc-editor.org/rfc/rfc9116#name-acknowledgments
    def acknowledgments(val = NOT_PROVIDED)
      return @acknowledgments if val == NOT_PROVIDED

      if val
        val = Array(val)
        unless val.all? { |uri| uri.start_with?("https://") }
          raise ArgumentError, "acknowledgments must all be HTTPS URIs"
        end
      end

      @acknowledgments = val
    end

    alias acknowledgments= acknowledgments

    # optional Array<String>
    # URIs indicating where security.txt is located; see https://www.rfc-editor.org/rfc/rfc9116#name-canonical
    def canonical(val = NOT_PROVIDED)
      return @canonical if val == NOT_PROVIDED

      if val
        val = Array(val)
        raise ArgumentError, "canonicals must all be HTTPS URIs" unless val.all? { |uri| uri.start_with?("https://") }
      end

      @canonical = val
    end

    alias canonical= canonical

    # optional Array<String>
    # URIs indicating where security.txt is located; see https://www.rfc-editor.org/rfc/rfc9116#name-canonical
    def contact(val = NOT_PROVIDED)
      return @contact if val == NOT_PROVIDED

      if val
        val = Array(val)
        unless val.all? { |uri| CONTACT_PREFIXES.any? { |prefix| uri.start_with?(prefix) } }
          raise ArgumentError, "contacts must all be mailto, tel, or HTTPS URIs"
        end
      end

      @contact = val
    end

    alias contact= contact

    # optional Array<String>
    # URI pointing to location where PGP encryption key is located; see https://www.rfc-editor.org/rfc/rfc9116.html#name-encryption
    def encryption(val = NOT_PROVIDED)
      return @encryption if val == NOT_PROVIDED

      if val
        val = Array(val)

        if val.any? { |uri| uri.start_with?("http://") }
          raise ArgumentError, "encryptions must not use plain HTTP schemes"
        end
      end

      @encryption = val
    end

    alias encryption= encryption

    def expires(val = NOT_PROVIDED)
      return @expires if val == NOT_PROVIDED

      if val.is_a?(String)
        val = Time.iso8601(val)
      elsif !val.respond_to?(:iso8601) && !val.nil?
        raise ArgumentError, "expires must be a String or respond to #iso8601"
      end

      @expires = val
    end

    alias expires= expires

    def hiring(val = NOT_PROVIDED)
      return @hiring if val == NOT_PROVIDED

      raise ArgumentError, "hirings must not use plain HTTP schemes" if val&.any? { |uri| uri.start_with?("http://") }

      @hiring = val
    end

    alias hiring= hiring

    def preferred_languages(val = NOT_PROVIDED)
      return @preferred_languages if val == NOT_PROVIDED

      @preferred_languages = Array(val) if val
    end

    alias preferred_languages= preferred_languages

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
