# frozen_string_literal: true

require_relative "fields"

module SecurityTxt
  class Config
    # Get or set security.txt fields.
    # If not given a block, returns Fields:
    #
    #   SecurityTxt::Config.new.fields # => #<SecurityTxt::Fields:...>
    #
    # If given a block with no parameters, evaluates the block on the Fields instance:
    #
    #   SecurityTxt::Config.new.fields do
    #     acknowledgments "https://www.example.com/thanks"
    #     canonical       "https://www.example.com/.well-known/security.txt"
    #   end
    #
    # If given a block with 1 or more parameters, yields Fields to the block:
    #
    #   SecurityTxt::Config.new.fields do |fields|
    #     fields.acknowledgments = "https://www.example.com/thanks"
    #     fields.canonical       = "https://www.example.com/.well-known/security.txt"
    #   end
    def fields(&block)
      @fields ||= SecurityTxt::Fields.new

      block_params = block&.parameters
      unless block_params.nil?
        if block_params.empty?
          @fields.instance_eval(&block)
        else
          block.call fields
        end
      end

      @fields
    end
  end
end
