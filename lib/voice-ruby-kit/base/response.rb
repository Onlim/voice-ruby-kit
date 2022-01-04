module VoiceRubyKit
  module Base
    class Response
      require "voice-ruby-kit/errors/slot_not_found_error"

      def initialize(channel, request)
        @channel = channel
        @request = request
        @response = {
            speech: {},
            card: {},
            list: {},
            quick_reply: {},
            reprompt: {},
            session_attributes: {},
            should_end_session: false,
            directives: []
        }

        @intents = request.intent if request && request.type == "INTENT_REQUEST"
      end

      def add_session_attribute(key, value)
        @response[:session_attributes][key.to_sym] = value
      end

      def add_speech(speech_text)
        @response[:speech] = if @channel.ssml?(speech_text)
                               @channel.add_speech_ssml(speech_text)
                            else
                               @channel.add_speech(speech_text)
                            end
      end

      def add_reprompt(speech_text)
        @response[:reprompt] = @channel.add_reprompt(self.add_speech(speech_text))
      end

      def add_card(card)
        @response[:card] = @channel.add_card(card)
      end

      def add_permission_card(permissions)
        @response[:card] = @channel.add_permission_card(permissions)
      end

      def add_quick_reply(chips)
        @response[:quick_reply] = @channel.add_quick_reply(chips)
      end

      def add_should_end_session(should_end_session)
        @response[:should_end_session] = should_end_session
      end

      def add_list(list_hash)
        @response[:list] = list_hash
      end

      def add_audio_url(url, token = "", offset = 0)
        @response[:directives] << @channel.add_audio_url(url, token, offset)
      end

      def delegate_dialog_response
        @response[:directives] = @channel.delegate_dialog_response(@intents)
      end

      def elicit_dialog_response(slot)
        @response[:directives] = @channel.elicit_slot_directive(slot, @intents)
      end

      def confirm_dialog_slot(slot)
        @response[:directives] = @channel.confirm_slot_directive(slot, @intents)
      end

      def confirm_dialog_intent
        @response[:directives] = @channel.confirm_dialog_intent(@intents)
      end

      def add_apl_directive(item)
        @response[:directives] = @channel.add_apl_directive(item)
      end

      def modify_slot(name, value, confirmation_status)
        raise SlotNotFoundError if @intents['slots'][name].nil?

        @intents['slots'][name]['value'] = value
        @intents['slots'][name]['confirmationStatus'] = confirmation_status
      end

      def build_response
        @channel.build_response(@response)
      end
    end
  end
end