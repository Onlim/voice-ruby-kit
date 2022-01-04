module VoiceRubyKit
  module Base
    class Request
      require 'base/api'
      require 'base/channel'
      require 'base/geolocation'
      require 'base/interface'
      require 'base/scope'
      require 'base/session'
      require 'base/slot'

      attr_reader  :uid, :type, :name, :json, :locale, :conversation_id, :session,
                   :scope, :interface, :api, :geolocation, :crawler

      def initialize(channel, json_request, action_uid = nil)
        @uid = channel.action_skill_uid(json_request, action_uid)
        raise ArgumentError, "Action/Skill uid should exist in all requests" if @uid.nil?

        @type            = "DEFAULT_TYPE"
        @name            = "DEFAULT_NAME"
        @json            = json_request
        @channel         = channel
        @locale          = channel.locale(json_request)
        @conversation_id = channel.conversation_id(json_request)
        @crawler         = channel.crawler?(json_request)

        @session         = Session.new(channel, json_request)
        @scope           = Scope.new(channel, json_request)
        @interface       = Interface.new(channel, json_request)
        @api             = Api.new(channel, json_request)
        @geolocation     = Geolocation.new(channel, json_request)
      end
    end

    def self.transform_keys_to_symbols(value)
      return value unless value.is_a?(Hash)
      hash = value.inject({}){|memo,(k,v)| memo[k.to_sym] = self.transform_keys_to_symbols(v); memo}
      return hash
    end
  end
end
