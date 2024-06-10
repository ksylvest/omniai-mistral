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

      module Role
        ASSISTANT = 'assistant'
        USER = 'user'
        SYSTEM = 'system'
      end

      # @raise [OmniAI::Error]
      #
      # @param prompt [String]
      # @param model [String] optional
      # @param format [Symbol] optional :text or :json
      # @param temperature [Float, nil] optional
      # @param stream [Proc, nil] optional
      #
      # @return [OmniAI::Mistral::Chat::Response]
      def completion(messages, model: Model::MEDIUM, temperature: nil, format: nil, stream: nil)
        request = OmniAI::Mistral::Chat::Request.new(client: @client, messages:, model:, temperature:, format:, stream:)
        request.process!
      end
    end
  end
end
