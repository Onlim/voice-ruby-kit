module VoiceRubyKit
  module Base
    class Interface
      def initialize(channel, json_request)
        @channel = channel
        @device = channel.device(json_request)
        @interfaces = channel.interfaces(json_request)
      end

      def device_id
        @device.dig("deviceId")
      end

      def available?
        !!@interfaces
      end

      def supported_interfaces
        @interfaces
      end

      def geolocation?
        @channel.geolocation?(@interfaces)
      end

      def audio?
        @channel.audio?(@interfaces)
      end

      def apl?
        @channel.apl?(@interfaces)
      end

      def display?
        @channel.display?(@interfaces)
      end

      def video?
        @channel.video?(@interfaces)
      end
    end
  end
end
