require 'voice-ruby-kit/requests/intent_request'

module VoiceRubyKit
  module Requests
    class OptionRequest < IntentRequest
      def initialize(channel, json_request, action_uid = nil)
        super

        @type = "OPTION_REQUEST"
        @name = "Display.ElementSelected"
        @slots = channel.add_selected_item_to_slots(json_request)
      end
    end
  end
end
