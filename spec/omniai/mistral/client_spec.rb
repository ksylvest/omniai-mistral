# frozen_string_literal: true

RSpec.describe OmniAI::Mistral::Client do
  subject(:client) { described_class.new }

  describe '#chat' do
    it 'proxies' do
      allow(OmniAI::Mistral::Chat).to receive(:process!)
      client.chat('Hello!')
      expect(OmniAI::Mistral::Chat).to have_received(:process!)
    end
  end

  describe '#connection' do
    it { expect(client.connection).to be_a(HTTP::Client) }
  end
end
