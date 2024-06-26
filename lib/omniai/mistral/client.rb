# frozen_string_literal: true

module OmniAI
  module Mistral
    # An Mistral client implementation. Usage:
    #
    # w/ `api_key``:
    #   client = OmniAI::Mistral::Client.new(api_key: '...')
    #
    # w/ ENV['MISTRAL_API_KEY']:
    #
    #   ENV['MISTRAL_API_KEY'] = '...'
    #   client = OmniAI::Mistral::Client.new
    #
    # w/ config:
    #
    #   OmniAI::Mistral.configure do |config|
    #     config.api_key = '...'
    #   end
    #
    #   client = OmniAI::Mistral::Client.new
    class Client < OmniAI::Client
      VERSION = 'v1'

      # @param api_key [String] optional - defaults to `OmniAI::Mistral.config.api_key`
      # @param host [String] optional - defaults to `OmniAI::Mistral.config.host`
      # @param logger [Logger] optional - defaults to `OmniAI::Mistral.config.logger`
      # @param timeout [Integer] optional - defaults to `OmniAI::Mistral.config.timeout`
      def initialize(
        api_key: OmniAI::Mistral.config.api_key,
        host: OmniAI::Mistral.config.host,
        logger: OmniAI::Mistral.config.logger,
        timeout: OmniAI::Mistral.config.timeout
      )
        raise(ArgumentError, %(ENV['MISTRAL_API_KEY'] must be defined or `api_key` must be passed)) if api_key.nil?

        super
      end

      # @return [HTTP::Client]
      def connection
        @connection ||= super.auth("Bearer #{api_key}")
      end

      # @raise [OmniAI::Error]
      #
      # @param messages [String, Array, Hash]
      # @param model [String] optional
      # @param format [Symbol] optional :text or :json
      # @param temperature [Float, nil] optional
      # @param stream [Proc, nil] optional
      #
      # @return [OmniAI::Chat::Completion]
      def chat(messages, model: Chat::Model::MEDIUM, temperature: nil, format: nil, stream: nil)
        Chat.process!(messages, model:, temperature:, format:, stream:, client: self)
      end
    end
  end
end
