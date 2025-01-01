# frozen_string_literal: true

RSpec.describe SpaceInvadersRadar::Matcher do
  describe '.compare' do
    subject(:score) { described_class.compare(pattern, sample) }

    let(:pattern) do
      [
        ['-', 'o', '-'],
        ['o', '-', 'o'],
        ['o', 'o', 'o']
      ]
    end

    let(:sample) do
      [
        ['o', 'o', '-'],
        ['o', '-', 'o'],
        ['o', 'o', '-']
      ]
    end

    let(:expected_score) { 0.71 }

    it 'returns expted score' do
      expect(score).to eq(expected_score)
    end

    context 'when there is no matches between pattern and sample' do
      let(:pattern) do
        [
          ['-', 'o'],
          ['o', '-']
        ]
      end

      let(:sample) do
        [
          ['o', '-'],
          ['-', 'o']
        ]
      end

      it 'returns 0.0 score' do
        expect(score).to eq(0.0)
      end
    end

    context 'when both pattern and sample does not contain pattern characters' do
      let(:pattern) do
        [
          ['-', '-'],
          ['-', '-']
        ]
      end

      let(:sample) do
        [
          ['-', '-'],
          ['-', '-']
        ]
      end

      it 'returns 0.0 score' do
        expect(score).to eq(0.0)
      end
    end
  end
end
