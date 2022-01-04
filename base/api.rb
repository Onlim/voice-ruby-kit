module VoiceRubyKit
  module Base
    class Api
      def initialize(channel, json_request)
        @system = channel.system(json_request)
      end

      def endpoint
        @system.dig("apiEndpoint")
      end

      def access_token
        @system.dig("apiAccessToken")
      end
    end
  end
end
