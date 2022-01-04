# frozen_string_literal: true
require 'voice-ruby-kit/base/handler'

module VoiceRubyKit
  class Assistant < Base::Handler
    def initialize
      super("assistant")
    end

    def self.build_request(json_request, action_uid)
      Base::Handler.new("assistant").build_request(json_request, action_uid)
    end

    def self.response(request_object)
      Base::Handler.new("assistant").response(request_object)
    end
  end
end

