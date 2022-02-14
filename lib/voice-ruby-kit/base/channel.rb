module VoiceRubyKit
  module Base
    class Channel

      def initialize
        @version = '1.0'
      end

      def crawler?(json_request)
        false
      end

      def request_valid?(json_request)
        false
      end

      def request_type(json_request)
        nil
      end

      def request_reason(json_request)
        nil
      end

      def request_error(json_request)
        nil
      end

      def action_skill_uid(json_request, action_uid)
        nil
      end

      def locale(json_request)
        nil
      end

      def session_valid?(json_request)
        false
      end

      def session_new?(json_request)
        false
      end

      def session_id(json_request)
        nil
      end

      def session_attributes(json_request)
        {}
      end

      def session_user(json_request)
        nil
      end

      def system(json_request)
        nil
      end

      def system_user(json_request)
        nil
      end

      def system_scopes(json_request)
        nil
      end

      def device(json_request)
        nil
      end

      def geolocation?(interfaces)
        false
      end

      def audio?(interfaces)
        false
      end

      def apl?(interfaces)
        false
      end

      def display?(interfaces)
        false
      end

      def video?(interfaces)
        false
      end

      def geolocation(json_request)
        nil
      end

      def conversation_id(json_request)
        nil
      end

      def intent(json_request)
        nil
      end

      def intent_name(intent)
        nil
      end

      def intent_slots(intent)
        nil
      end

      def intent_query(intent)
        nil
      end

      def add_selected_item_to_slots(json_request)
        {}
      end

      def add_speech_ssml(speech_text)
        {}
      end

      def add_speech(speech_text)
        {}
      end

      def add_reprompt(speech_object)
        {}
      end

      def add_card(card)
        {}
      end

      def add_permission_card(permissions)
        {}
      end

      def add_quick_reply(chips)
        {}
      end

      def add_audio_url(url, token = '', offset = 0)
        {}
      end

      def delegate_dialog_response(intents)
        []
      end

      def elicit_dialog_response(slot, intents)
        []
      end

      def confirm_dialog_slot(slot, intents)
        []
      end

      def confirm_dialog_intent(intents)
        []
      end

      def add_apl_directive(item)
        []
      end

      def build_response(response)
        nil
      end

      def ssml?(string)
        false
      end

      def check_ssml(ssml_string)
        ssml_string = ssml_string.gsub(%r{</?speak>}, '')
        ssml_string = ssml_string.gsub(%r{<br\s*/?>}, '')
        ssml_string.delete!("\n")
        ssml_string = "<speak>#{ssml_string}</speak>"
        ssml_string.squish
      end
    end
  end
end
