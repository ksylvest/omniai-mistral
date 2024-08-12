# frozen_string_literal: true

RSpec.describe OmniAI::Mistral::Chat do
  let(:client) { OmniAI::Mistral::Client.new }

  describe '.process!' do
    subject(:completion) { described_class.process!(prompt, client:, model:) }

    let(:model) { OmniAI::Mistral::Chat::Model::MEDIUM }

    context 'with a string prompt' do
      let(:prompt) { 'Tell me a joke!' }

      before do
        stub_request(:post, 'https://api.mistral.ai/v1/chat/completions')
          .with(body: {
            messages: [{ role: 'user', content: prompt }],
            model:,
          })
          .to_return_json(body: {
            choices: [{
              index: 0,
              message: {
                role: 'assistant',
                content: 'Two elephants fall off a cliff. Boom! Boom!',
              },
            }],
          })
      end

      it { expect(completion.choice.message.role).to eql('assistant') }
      it { expect(completion.choice.message.content).to eql('Two elephants fall off a cliff. Boom! Boom!') }
    end

    context 'with an array prompt' do
      let(:prompt) do
        OmniAI::Chat::Prompt.build do |prompt|
          prompt.system('You are a helpful assistant.')
          prompt.user('What is the capital of Canada?')
        end
      end

      before do
        stub_request(:post, 'https://api.mistral.ai/v1/chat/completions')
          .with(body: {
            messages: [
              { role: 'system', content: 'You are a helpful assistant.' },
              { role: 'user', content: 'What is the capital of Canada?' },
            ],
            model:,
          })
          .to_return_json(body: {
            choices: [{
              index: 0,
              message: {
                role: 'assistant',
                content: 'The capital of Canada is Ottawa.',
              },
            }],
          })
      end

      it { expect(completion.choice.message.role).to eql('assistant') }
      it { expect(completion.choice.message.content).to eql('The capital of Canada is Ottawa.') }
    end

    context 'with a temperature' do
      subject(:completion) { described_class.process!(prompt, client:, model:, temperature:) }

      let(:prompt) { 'Pick a number between 1 and 5.' }
      let(:temperature) { 2.0 }

      before do
        stub_request(:post, 'https://api.mistral.ai/v1/chat/completions')
          .with(body: {
            messages: [{ role: 'user', content: prompt }],
            model:,
            temperature:,
          })
          .to_return_json(body: {
            choices: [{
              index: 0,
              message: {
                role: 'assistant',
                content: '3',
              },
            }],
          })
      end

      it { expect(completion.choice.message.role).to eql('assistant') }
      it { expect(completion.choice.message.content).to eql('3') }
    end

    context 'when formatting as JSON' do
      subject(:completion) { described_class.process!(prompt, client:, model:, format: :json) }

      let(:prompt) do
        OmniAI::Chat::Prompt.build do |prompt|
          prompt.system(OmniAI::Chat::JSON_PROMPT)
          prompt.user('What is the name of the dummer for the Beatles?')
        end
      end

      before do
        stub_request(:post, 'https://api.mistral.ai/v1/chat/completions')
          .with(body: {
            messages: [
              { role: 'system', content: OmniAI::Chat::JSON_PROMPT },
              { role: 'user', content: 'What is the name of the dummer for the Beatles?' },
            ],
            model:,
            response_format: { type: 'json_object' },
          })
          .to_return_json(body: {
            choices: [{
              index: 0,
              message: {
                role: 'assistant',
                content: '{ "name": "Ringo" }',
              },
            }],
          })
      end

      it { expect(completion.choice.message.role).to eql('assistant') }
      it { expect(completion.choice.message.content).to eql('{ "name": "Ringo" }') }
    end

    context 'when streaming' do
      subject(:completion) { described_class.process!(prompt, client:, model:, stream:) }

      let(:prompt) { 'Tell me a story.' }
      let(:stream) { proc { |chunk| } }

      before do
        stub_request(:post, 'https://api.mistral.ai/v1/chat/completions')
          .with(body: {
            messages: [
              { role: 'user', content: 'Tell me a story.' },
            ],
            model:,
            stream: !stream.nil?,
          })
          .to_return(body: <<~STREAM)
            data: #{JSON.generate({ choices: [{ delta: { role: 'assistant', content: 'A' } }] })}\n
            data: #{JSON.generate({ choices: [{ delta: { role: 'assistant', content: 'B' } }] })}\n
            data: [DONE]\n
          STREAM
      end

      it do
        chunks = []
        allow(stream).to receive(:call) { |chunk| chunks << chunk }
        completion
        expect(chunks.map(&:content)).to eql(%w[A B])
      end
    end
  end
end
