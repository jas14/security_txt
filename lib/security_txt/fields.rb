# frozen_string_literal: true

module SecurityTxt
  class Fields
    NOT_PROVIDED = Object.new.freeze

    attr_writer :acknowledgments

    def initialize(acknowledgments: nil)
      self.acknowledgments = acknowledgments
    end

    # optional, singular
    # URI indicating the Acknowledgments page; see https://www.rfc-editor.org/rfc/rfc9116#name-acknowledgments
    def acknowledgments(val = NOT_PROVIDED)
      return @acknowledgments if val == NOT_PROVIDED

      # TODO: validate val (must begin with https:// if web address)
      @acknowledgments = val
    end

    def to_h
      {
        'Acknowledgments' => acknowledgments,
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
