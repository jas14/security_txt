# frozen_string_literal: true

module SecurityTxt
  class Config
    def fields # TODO: accept block?
      @fields ||= SecurityTxt::Fields.new
    end
  end
end
