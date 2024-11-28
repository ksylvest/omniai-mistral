# frozen_string_literal: true

module OmniAI
  module Mistral
    # A Mistral chat implementation.
    #
    # Usage:
    #
    #   chat = OmniAI::Mistral::Chat.new(client: client)
    #   chat.completion('Tell me a joke.')
    #   chat.completion(['Tell me a joke.'])
    #   chat.completion({ role: 'user', content: 'Tell me a joke.' })
    #   chat.completion([{ role: 'system', content: 'Tell me a joke.' }])
    class Chat < OmniAI::Chat
      module Model
        MISTRAL_SMALL_2409 = 'mistral-small-2409'
        MISTRAL_SMALL_LATEST = 'mistral-small-latest'
        MISTRAL_MEDIUM_2312 = 'mistral-medium-2312' # LEGACY
        MISTRAL_MEDIUM_LATEST = 'mistral-medium-latest' # LEGACY
        MISTRAL_LARGE_2411 = 'mistral-large-2411'
        MISTRAL_LARGE_LATEST = 'mistral-large-latest'
        CODESTRAL_2405 = 'codestral-2405'
        CODESTRAL_LATEST = 'codestral-latest'
        MINISTRAL_3B_2410 = 'ministral-3b-2410'
        MINISTRAL_3B_LATEST = 'ministral-3b-latest'
        MINISTRAL_8B_2410 = 'ministral-8b-2410'
        MINISTRAL_8B_LATEST = 'ministral-8b-latest'
        MISTRAL_MODERATION_2411 = 'mistral-moderation-2411'
        MISTRAL_MODERATION_LATEST = 'mistral-moderation-latest'
        MISTRAL_EMBED = 'mistral-embed'
        PIXTRAL_LARGE_2411 = 'pixtral-large-2411'
        PIXTRAL_LARGE_LATEST = 'pixtral-large-latest'
        SMALL = MISTRAL_SMALL_LATEST
        MEDIUM = MISTRAL_MEDIUM_LATEST # LEGACY
        LARGE = MISTRAL_LARGE_LATEST
        PIXTRAL = PIXTRAL_LARGE_LATEST
        CODESTRAL = CODESTRAL_LATEST
      end

      DEFAULT_MODEL = Model::PIXTRAL_LARGE_LATEST

      module Role
        ASSISTANT = 'assistant'
        USER = 'user'
        SYSTEM = 'system'
      end

      JSON_RESPONSE_FORMAT = { type: 'json_object' }.freeze

      protected

      # @return [Hash]
      def payload
        OmniAI::Mistral.config.chat_options.merge({
          messages: @prompt.serialize,
          model: @model,
          stream: @stream.nil? ? nil : !@stream.nil?,
          temperature: @temperature,
          response_format: (JSON_RESPONSE_FORMAT if @format.eql?(:json)),
          tools: (@tools.map(&:serialize) if @tools&.any?),
        }).compact
      end

      # @return [String]
      def path
        "/#{OmniAI::Mistral::Client::VERSION}/chat/completions"
      end
    end
  end
end
