require 'voice-ruby-kit/base/request'

module VoiceRubyKit
  module Requests
    class IntentRequest < VoiceRubyKit::Base::Request
      attr_accessor :intent, :name, :slots, :query
      def initialize(channel, json_request, action_uid = nil)
        super
        @intent = channel.intent(json_request)
        @type = 'INTENT_REQUEST'
        @name  = channel.intent_name(json_request)
        @slots = channel.intent_slots(json_request)
        @query = channel.intent_query(json_request)
      end
    end
  end
end