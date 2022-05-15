# frozen_string_literal: true

module SecurityTxt
  class Fields
    CONTACT_PREFIXES = ["https://", "mailto:", "tel:"].freeze
    NOT_PROVIDED = Object.new.freeze

    def initialize(acknowledgments: nil, canonical: nil, contact: nil)
      self.acknowledgments = acknowledgments
      self.canonical = canonical
      self.contact = contact
    end

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

    def to_h
      {
        "Acknowledgments" => acknowledgments,
        "Canonical" => canonical,
        "Contact" => contact,
      }.compact
    end

    def to_s
      to_h.compact.flat_map do |field_name, field_value|
        field_values = Array(field_value)
        field_values.map { |v| "#{field_name}: #{v}" }
      end.join("\n\n")
    end
  end
end
