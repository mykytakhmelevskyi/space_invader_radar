# frozen_string_literal: true

RSpec.describe SpaceInvadersRadar::InvadersDetector do
  let(:radar_sample)    { instance_double(SpaceInvadersRadar::RadarSample, width: 5, height: 5) }
  let(:invader_pattern) { instance_double(SpaceInvadersRadar::InvaderPattern) }
  let(:invader_patterns) { [invader_pattern] }

  let(:accuracy)   { 0.8 }
  let(:visibility) { 0.25 }

  let(:instance) { described_class.new(radar_sample, invader_patterns, accuracy, visibility) }

  describe '#detect_invaders' do
    subject(:detection_result) { instance.detect_invaders }

    let(:sliding_window_double) { instance_double(SpaceInvadersRadar::SlidingWindow) }
    let(:matcher) { SpaceInvadersRadar::Matcher }
    let(:cache_manager_double) { instance_double(SpaceInvadersRadar::MatchesCacheManager) }
    let(:matches_collector_double) { instance_double(SpaceInvadersRadar::MatchesCollector) }

    let(:matches) { [[1, 2], [2, 3]] }

    let(:expected_result) do
      [
        {
          pattern: invader_pattern,
          matches: matches
        }
      ]
    end

    before do
      allow(SpaceInvadersRadar::SlidingWindow).to receive(:new)
        .with(radar_sample, invader_pattern)
        .and_return(sliding_window_double)

      allow(SpaceInvadersRadar::Matcher).to receive(:compare)

      allow(SpaceInvadersRadar::MatchesCacheManager).to receive(:new)
        .with(radar_sample.width, radar_sample.height)
        .and_return(cache_manager_double)

      allow(SpaceInvadersRadar::MatchesCollector).to receive(:new)
        .with(sliding_window_double, matcher, cache_manager_double, accuracy, visibility)
        .and_return(matches_collector_double)

      allow(matches_collector_double).to receive(:find_matches).and_return(matches)
    end

    it 'returns an array of results presented as hashes' do
      expect(detection_result).to eq(expected_result)
    end

    it 'calls MatchesCollector.new with correct arguments' do
      detection_result

      expect(SpaceInvadersRadar::MatchesCollector).to have_received(:new).with(
        sliding_window_double,
        matcher,
        cache_manager_double,
        accuracy,
        visibility
      )
    end

    it 'calls #find_matches on the MatchesCollector object' do
      detection_result

      expect(matches_collector_double).to have_received(:find_matches)
    end
  end
end
