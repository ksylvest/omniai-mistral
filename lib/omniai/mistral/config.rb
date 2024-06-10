# frozen_string_literal: true

module OmniAI
  module Mistral
    # Config for the Mistral `api_key` / `host` / `logger`.
    class Config < OmniAI::Config
      def initialize
        super
        @api_key = ENV.fetch('MISTRAL_API_KEY', nil)
        @host = ENV.fetch('MISTRAL_HOST', 'https://api.mistral.ai')
      end
    end
  end
end
