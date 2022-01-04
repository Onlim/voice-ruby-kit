# frozen_string_literal: true
require 'base/handler'

module VoiceRubyKit
  class Alexa < Base::Handler
    def initialize
      super("alexa")
    end

    def self.build_request(json_request)
      Base::Handler.new("alexa").build_request(json_request)
    end

    def self.response(request_object)
      Base::Handler.new("alexa").response(request_object)
    end
  end
end
