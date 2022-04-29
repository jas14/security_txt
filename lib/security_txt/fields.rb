# frozen_string_literal: true

module SecurityTxt
  class Fields
    NOT_PROVIDED = Object.new.freeze

    def initialize(acknowledgments: nil)
      self.acknowledgments = acknowledgments
    end

    # optional, singular
    # URI indicating the Acknowledgments page; see https://www.rfc-editor.org/rfc/rfc9116#name-acknowledgments
    def acknowledgments(val = NOT_PROVIDED)
      return @acknowledgments if val == NOT_PROVIDED

      raise ArgumentError, "acknowledgements must begin with https://" if val && !val.start_with?("https://")

      @acknowledgments = val
    end

    alias acknowledgments= acknowledgments

    def to_h
      {
        "Acknowledgments" => acknowledgments
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
