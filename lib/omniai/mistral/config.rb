# frozen_string_literal: true

module OmniAI
  module Mistral
    # Config for the Mistral `api_key` / `host` / `logger`, `chat_options`.
    class Config < OmniAI::Config
      attr_accessor :chat_options

      def initialize
        super
        @api_key = ENV.fetch('MISTRAL_API_KEY', nil)
        @host = ENV.fetch('MISTRAL_HOST', 'https://api.mistral.ai')
        @chat_options = {}
      end
    end
  end
end
