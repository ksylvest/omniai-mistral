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
        SMALL = 'mistral-small-latest'
        MEDIUM = 'mistral-medium-latest'
        LARGE = 'mistral-large-latest'
        CODESTRAL = 'codestral-latest'
      end

      DEFAULT_MODEL = Model::LARGE

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
          tools: @tools&.map(&:serialize),
        }).compact
      end

      # @return [String]
      def path
        "/#{OmniAI::Mistral::Client::VERSION}/chat/completions"
      end
    end
  end
end
