# frozen_string_literal: true
module VoiceRubyKit
  module Base
    class Session
      attr_reader :new, :session_id, :attributes, :user

      def initialize(channel, json_request)
        raise ArgumentError, "Invalid Session" unless channel.session_valid?(json_request)

        @new = channel.session_new?(json_request)
        @session_id = channel.session_id(json_request)
        @attributes = channel.session_attributes(json_request)
        @user = channel.session_user(json_request)
      end

      def new?
        @new
      end

      def user_defined?
        @user.present? || @user["userId"].present?
      end

      def user_id
        @user["userId"] if @user.present?
      end

      def access_token
        @user["accessToken"] if @user.present?
      end

      def attributes?
        @attributes.present?
      end
    end
  end
end
