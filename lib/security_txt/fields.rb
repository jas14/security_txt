# frozen_string_literal: true

module SecurityTxt
  class Fields
    NOT_PROVIDED = Object.new.freeze

    def initialize(acknowledgments: nil, canonical: nil)
      self.acknowledgments = acknowledgments
      self.canonical = canonical
    end

    # optional String
    # URI indicating the Acknowledgments page; see https://www.rfc-editor.org/rfc/rfc9116#name-acknowledgments
    def acknowledgments(val = NOT_PROVIDED)
      return @acknowledgments if val == NOT_PROVIDED

      raise ArgumentError, "acknowledgements must begin with https://" if val && !val.start_with?("https://")

      @acknowledgments = val
    end

    alias acknowledgments= acknowledgments

    # optional Array<String>
    # URIs indicating the URIs where security.txt is located; see https://www.rfc-editor.org/rfc/rfc9116#name-canonical
    def canonical(val = NOT_PROVIDED)
      return @canonical if val == NOT_PROVIDED

      if val
        val = Array(val)
        unless val.all? { |uri| uri.start_with?("https://") }
          raise ArgumentError, "canonical must be an array of https URIs"
        end
      end

      @canonical = val
    end

    alias canonical= canonical

    def to_h
      {
        "Acknowledgments" => acknowledgments,
        "Canonical" => canonical,
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
