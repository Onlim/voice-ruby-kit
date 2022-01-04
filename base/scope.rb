module VoiceRubyKit
  module Base
    class Scope
      def initialize(channel, json_request)
        @scopes = channel.system_scopes(json_request)
      end

      def available?
        !!@scopes
      end

      def list
        @scopes if available?
      end

      def status?(permission)
        if available?
          @scopes.dig(permission, "status")
        end
      end

      def granted?(permission)
        status?(permission) == "GRANTED"
      end
    end
  end
end
