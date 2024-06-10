# frozen_string_literal: true

RSpec.describe OmniAI::Mistral::Client do
  subject(:client) { described_class.new }

  describe '#chat' do
    it { expect(client.chat).to be_a(OmniAI::Mistral::Chat) }
  end

  describe '#connection' do
    it { expect(client.connection).to be_a(HTTP::Client) }
  end
end
