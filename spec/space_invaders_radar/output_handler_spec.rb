# frozen_string_literal: true

RSpec.describe SpaceInvadersRadar::OutputHandler do
  let(:output_handler) { described_class.new(results, radar_sample) }

  let(:radar_data) do
    [
      ['-', '-'],
      ['-', 'o']
    ]
  end

  let(:invader_data) do
    [
      ['o', '-'],
      ['-', 'o']
    ]
  end

  let(:radar_sample)    { SpaceInvadersRadar::RadarSample.new(radar_data.map(&:join).join("\n")) }
  let(:invader_pattern) { SpaceInvadersRadar::InvaderPattern.new(invader_data.map(&:join).join("\n")) }

  let(:results) do
    [
      {
        pattern: invader_pattern,
        matches: [[0, 0]]
      }
    ]
  end

  let(:expected_output) do
    <<~OUTPUT
      ===== Detection Summary =====
      Pattern #1: Found 1 matches.
          \e[31mo\e[0m-
          -\e[31mo\e[0m
      =============================

      ===== Radar Sample with Detected Invaders =====
      \e[31mx\e[0m-
      -\e[31mo\e[0m
    OUTPUT
  end

  describe '#display' do
    subject(:display) { output_handler.display }

    it 'prints the detection summary' do
      expect { display }.to output(expected_output).to_stdout
    end
  end
end
