# frozen_string_literal: true

require 'voice-ruby-kit/base/channel'

module VoiceRubyKit
  module Channels
    class Assistant < Base::Channel
      def crawler?(json_request)
        json_request.dig("user", "profile", "givenName") == "Google"
      end

      def request_valid?(json_request)
        json_request["inputs"].present? &&
          json_request.dig("conversation", "conversationId").present? &&
          json_request.dig("user", "locale").present?
      end

      def request_type(json_request)
        json_request["inputs"][0]["intent"]
      end

      def action_skill_uid(_, action_uid)
        action_uid
      end

      def locale(json_request)
        json_request.dig("user", "locale")
      end

      def session_valid?(json_request)
        json_request.present? &&
          json_request["conversation"].present?
      end

      def session_new?(json_request)
        json_request.dig("conversation", "type") == "NEW"
      end

      def session_id(json_request)
        json_request.dig("session", "sessionId")
      end

      def session_attributes(json_request)
        return {} if json_request.dig("conversation", "conversationToken").nil?

        JSON.parse(json_request["conversation"]["conversationToken"])
      end

      def interfaces(json_request)
        json_request.dig("surface", "capabilities")
      end

      def audio?(interfaces)
        self.find_interface(interfaces, "actions.capability.AUDIO_OUTPUT")
      end

      def display?(interfaces)
        self.find_interface(interfaces, "actions.capability.SCREEN_OUTPUT")
      end

      def conversation_id(json_request)
        json_request.dig("conversation", "conversationId")
      end

      def intent(json_request)
        json_request.dig("inputs", 0)
      end

      def intent_name(json_request)
        self.intent(json_request).dig("intent")
      end

      def intent_slots(json_request)
        json_request.dig("inputs",0,"arguments")
      end

      def intent_query(json_request)
        self.intent(json_request).dig("rawInputs", 0, "query")
      end

      def add_selected_item_to_slots(json_request)
        {
            selected: json_request["inputs"][0]["arguments"][0]["textValue"]
        }
      end

      def add_speech(speech_text)
        speech_text.delete!("\n")
        speech_text.squish

        speech_text = check_ssml(speech_text) if ssml?(speech_text)
        speech_response(speech_text)
      end

      def add_speech_ssml(speech_text)
        self.add_speech(speech_text)
      end

      def add_reprompt(speech_object)
        speech_object
      end

      def add_card(card)
        {
            basicCard: card
        }
      end

      def add_quick_reply(chips)
        {
            suggestions: chips
        }
      end

      def build_response(response)
        response_hash = {}
        response_hash[:expectUserResponse] = !response.dig(:should_end_session)
        if response.dig(:should_end_session)
          response_hash[:finalResponse] = create_rich_response(response)
        else
          response_hash[:expectedInputs] = []
          response_hash[:expectedInputs].push(
              inputPrompt: create_rich_response(response),
              possibleIntents: create_possible_intents(response)
          )
        end
        response_hash[:conversationToken] = response.dig(:session_attributes).to_json if response.dig(:session_attributes).present?
        response_hash.to_json
      end

      def ssml?(string)
        string.match(%r{</?[a-z][\s\S]*>}i)
      end

      private

      def create_list_hash(list)
        hash = {
            "@type" => "type.googleapis.com/google.actions.v2.OptionValueSpec",
            "listSelect" => list
        }
        hash
      end

      def create_rich_response(response)
        items = []
        items << response[:speech] if response.dig(:speech,:simpleResponse).present?
        items << response[:card] if response.dig(:card,:basicCard).present?

        response_type = response.dig(:should_end_session) ? "richResponse" : "richInitialPrompt"

        response_hash = {}
        response_hash[response_type] = { items: items }
        response_hash[response_type].merge!(response.dig(:quick_reply)) if response.dig(:quick_reply,:suggestions).present?
        response_hash
      end

      def create_possible_intents(response)
        response_hash = {}
        if response.dig(:list).present?
          response_hash[:intent] = "actions.intent.OPTION"
          response_hash[:inputValueData] = create_list_hash(response.dig(:list))
        else
          response_hash[:intent] = "actions.intent.TEXT"
        end
        [response_hash]
      end

      def find_interface(interfaces, interface)
        interfaces.any? { |h| h["name"] == interface }
      end

      def prepare_speech(speech)
        speech.delete!("\n")
        speech.squish
      end

      def speech_response(speech_text)
        {
            simpleResponse: {
                textToSpeech: speech_text,
                displayText: speech_text
            }
        }
      end
    end
  end
end
