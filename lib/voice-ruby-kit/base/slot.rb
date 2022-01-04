module VoiceRubyKit
  module Base
    class Slot
      attr_accessor :name, :value
      def initialize(name, value)
        raise ArgumentError, 'Need a name and a value' if name.nil? || value.nil?
        @name = name
        @value = value
      end

      def to_s
        "Slot Name: #{name}, Value: #{value}"
      end
    end
  end
end