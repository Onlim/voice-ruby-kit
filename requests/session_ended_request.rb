module VoiceRubyKit
  module Requests
    class SessionEndedRequest < VoiceRubyKit::Base::Request
      attr_accessor :reason
      def initialize(channel, json_request, action_uid = nil)
      super
        @type = 'SESSION_ENDED_REQUEST'
        @reason = channel.request_reason(json_request)
        @error = channel.request_error(json_request)
      end

      def error_available?
        !!@error
      end

      def error_type
        if error_available?
          @error.dig("type")
        end
      end

      def error_message
        if error_available?
          @error.dig("message")
        end
      end
    end
  end
end