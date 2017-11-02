# frozen_string_literal: true

require 'json'

require 'gitmodules_parser'

RSpec.describe Parsers::GitmodulesParser do
  describe '#parse' do
    context 'when a valid gitmodules is provided' do
      let(:gitmodules) { fixture('gitmodules') }
      let(:expected) { fixture('gitmodules.json').read }
      subject { described_class.new(gitmodules).parse }

      it 'returns a json representation of it' do
        expect(subject).to eq(expected)
      end
    end

    context 'when an empty gitmodules is provided' do
      let(:gitmodules) { fixture('gitmodules_empty') }
      subject { described_class.new(gitmodules).parse }

      it 'returns an empty json object' do
        expect(subject).to eq('{}')
      end
    end

    context 'when the gitmodules provided does not exist' do
      let(:gitmodules) { '' }
      subject { described_class.new(gitmodules).parse }

      it 'returns an empty json object' do
        expect(subject).to eq('{}')
      end
    end
  end
end
