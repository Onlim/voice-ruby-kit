module VoiceRubyKit
  module Requests
    class LaunchRequest < IntentRequest
      def initialize(channel, json_request, action_uid = nil)
        super
        @type = 'LAUNCH_REQUEST'
        @name = 'LAUNCH_REQUEST'
      end
    end
  end
end