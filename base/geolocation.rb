module VoiceRubyKit
  module Base
    class Geolocation
      def initialize(channel, json_request)
        @geolocation = channel.geolocation(json_request)
      end

      def available?
        !!@geolocation
      end

      def location_services_status?
        if available?
          @geolocation.dig("locationServices", "status")
        end
      end

      def location_services_access?
        if available?
          @geolocation.dig("locationServices", "access")
        end
      end

      def location_services_running?
        location_services_status? == "RUNNING"
      end

      def location_services_enabled?
        location_services_access? == "ENABLED"
      end

      def latitude
        if available?
          @geolocation.dig("coordinate", "latitudeInDegrees")
        end
      end

      def longitude
        if available?
          @geolocation.dig("coordinate", "longitudeInDegrees")
        end
      end
    end
  end
end
