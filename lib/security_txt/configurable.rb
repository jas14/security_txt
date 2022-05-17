# frozen_string_literal: true

module SecurityTxt
  # Shortcut for some DSL boilerplate behavior.
  # Extend this module and call `field :<name> { |val| ... }` to define a new DSL field.
  #
  # The optional block is for value transformation and is called when a field value is being set.
  # It should take the new raw value and return the (postprocessed) actual new value which will be assigned
  # to the relevant instance variable.
  module Configurable
    NOT_PROVIDED = Object.new.freeze

    def field(name)
      define_method(name) do |val = NOT_PROVIDED|
        return instance_variable_get(:"@#{name}") if val == NOT_PROVIDED

        val = yield val if block_given?

        instance_variable_set(:"@#{name}", val)
      end

      alias_method(:"#{name}=", name)
    end
  end
end
