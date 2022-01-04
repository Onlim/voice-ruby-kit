# frozen_string_literal: true

module VoiceRubyKit
  module Base
    class Handler
      require 'errors/unsupported_platform_error'
      require 'errors/invalid_request_error'
      require 'channels/alexa'
      require 'channels/assistant'
      require 'requests/launch_request'
      require 'requests/intent_request'
      require 'requests/option_request'
      require 'requests/session_ended_request'
      require 'base/response'

      PLATFORMS = %w[alexa assistant].freeze

      PLATFORMS.each do |platform|
        define_method("#{platform}?") do
          @platform == platform
        end
      end

      def initialize(platform)
        raise UnsupportedPlatformError unless PLATFORMS.include?(platform)

        @platform = platform
        @channel = Channels.const_get(platform.camelcase).new
      end

      def build_request(json_request, action_uid = nil)
        unless @channel.request_valid?(json_request)
          raise InvalidRequestError,
                "Invalid #{@platform} request with payload: #{json_request}"
        end

        case @channel.request_type(json_request)
        when /actions.intent.MAIN/, /Launch/
          Requests::LaunchRequest.new(@channel, json_request, action_uid)
        when /actions.intent.OPTION/, /Display.ElementSelected/, /Alexa.Presentation.APL.UserEvent/
          Requests::OptionRequest.new(@channel, json_request, action_uid)
        when /Intent/
          Requests::IntentRequest.new(@channel, json_request, action_uid)
        when /SessionEnded/
          Requests::SessionEndedRequest.new(@channel, json_request, action_uid)
        else
          raise InvalidRequestError, "Invalid Request Type: #{@channel.request_type(json_request)}" if self.alexa?

          Requests::IntentRequest.new(@channel, json_request, action_uid)
        end
      end

      def response(request_object)
        Base::Response.new(@channel, request_object)
      end
    end
  end
end
