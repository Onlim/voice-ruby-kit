# frozen_string_literal: true

require 'base/channel'

module VoiceRubyKit
  module Channels
    class Alexa < Base::Channel
      require 'channels/helpers/apl'
      require 'channels/helpers/dialog'

      def initialize
        super
        @version = "1.0"
      end

      def request_valid?(json_request)
        json_request.present? &&
          json_request["session"].present? &&
          json_request["version"].present? &&
          json_request["request"].present?
      end

      def request_type(json_request)
        json_request.dig("request", "type")
      end

      def request_reason(json_request)
        json_request.dig("request","reason")
      end

      def request_error(json_request)
        json_request.dig("request","error")
      end

      def action_skill_uid(json_request, action_uid = nil)
        json_request.dig("request", "requestId")
      end

      def locale(json_request)
        json_request.dig("request", "locale")
      end

      def session_valid?(json_request)
        json_request.present? &&
            !json_request.dig("session", "new").nil? &&
             json_request.dig("session", "sessionId").present?
      end

      def session_new?(json_request)
        json_request.dig("session", "new")
      end

      def session_id(json_request)
        json_request.dig("session", "sessionId")
      end

      def session_attributes(json_request)
        json_request.dig("session", "attributes").nil? ? {}  : json_request.dig("session", "attributes")
      end

      def session_user(json_request)
        json_request.dig("session", "user")
      end

      def system(json_request)
        json_request.dig("context", "System")
      end

      def system_user(json_request)
        json_request.dig("context", "System", "user")
      end

      def system_scopes(json_request)
        self.system_user(json_request).dig("permissions", "scopes")
      end

      def device(json_request)
        json_request.dig("context","System","device")
      end

      def interfaces(json_request)
        self.device(json_request).dig("supportedInterfaces")
      end

      def geolocation?(interfaces)
        !!interfaces["Geolocation"]
      end

      def audio?(interfaces)
        !!interfaces["AudioPlayer"]
      end

      def apl?(interfaces)
        !!interfaces["Alexa.Presentation.APL"]
      end

      def display?(interfaces)
        !!interfaces["Display"]
      end

      def video?(interfaces)
        !!interfaces["VideoApp"]
      end

      def geolocation(json_request)
        json_request.dig("context", "Geolocation")
      end

      def conversation_id(json_request)
        self.session_id(json_request)
      end

      def intent(json_request)
        json_request.dig("request", "intent")
      end

      def intent_name(json_request)
        json_request.dig("request", "intent","name")
      end

      def intent_slots(json_request)
        json_request.dig("request", "intent","slots")
      end

      def add_selected_item_to_slots(json_request)
        value = json_request.dig("request", "arguments").first if json_request.dig("request", "arguments").present?
        value = json_request.dig("request", "token") if json_request.dig("request", "token").present?
        {
            'selected' => {
                'name' => 'selected',
                'value' => value,
                'confirmationStatus' => 'NONE',
                'source' => 'USER'
            }
        }
      end

      def add_speech_ssml(speech_text)
        { type: 'SSML', ssml: check_ssml(speech_text) }
      end

      def add_speech(speech_text)
        { type: 'PlainText', text: speech_text }
      end

      def add_reprompt(speech_object)
        {
            outputSpeech: speech_object
        }
      end

      def add_card(card)
        card[:type] = 'Simple' if card[:type].nil?
        card
      end

      def add_permission_card(permissions)
        {
            type: "AskForPermissionsConsent",
            permissions: permissions
        }
      end

      def add_audio_url(url, token = "", offset = 0)
        {
            "type" => "AudioPlayer.Play",
            "playBehavior" => "REPLACE_ALL",
            "audioItem" => {
                "stream" => {
                    "token" => token,
                    "url" => url,
                    "offsetInMilliseconds" => offset
                }
            }
        }
      end

      def delegate_dialog_response(intents)
        [Helpers::Dialog.delegate_directive(intents)]
      end

      def elicit_dialog_response(slot, intents)
        [Helpers::Dialog.elicit_slot_directive(slot, intents)]
      end

      def confirm_dialog_slot(slot, intents)
        [Helpers::Dialog.confirm_slot_directive(slot, intents)]
      end

      def confirm_dialog_intent(intents)
        [Helpers::Dialog.confirm_intent_directive(intents)]
      end

      def add_apl_directive(item)
        [Helpers::Apl.directive(item)]
      end

      def build_response(response)
        response_hash = {}
        response_hash[:version]           = @version
        response_hash[:sessionAttributes] = response[:session_attributes] unless response.dig(:session_attributes).blank?
        response_hash[:response]          = build_response_object(response)
        response_hash.to_json
      end

      def ssml?(string)
        string.match(/<\/?[a-z][\s\S]*>/i)
      end

      private

      def build_response_object(response)
        response_object = {}
        response_object[:outputSpeech]      = response.dig(:speech) unless response.dig(:speech).blank?
        response_object[:directives]        = response.dig(:directives) unless response.dig(:directives).blank?
        response_object[:card]              = response.dig(:card) unless response.dig(:card).blank?
        response_object[:reprompt]          = response.dig(:reprompt) unless response.dig(:reprompt).blank? && response.dig(:should_end_session)
        response_object[:shouldEndSession] = response.dig(:should_end_session) unless response.dig(:should_end_session).nil?
        response_object
      end
    end
  end
end
