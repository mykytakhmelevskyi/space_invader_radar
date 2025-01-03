# frozen_string_literal: true

module SpaceInvadersRadar
  # InvadersDetector:
  # This class is responsible for analyzing a radar sample against multiple invader patterns.
  # It uses a MatcherCollector instance for each pattern, applying configurable accuracy and visibility
  # thresholds. The result is a collection of detected matches for each invader.
  class InvadersDetector
    def initialize(radar_sample, invader_patterns, accuracy, visibility)
      @radar_sample = radar_sample
      @invader_patterns = invader_patterns
      @accuracy = accuracy
      @visibility = visibility
    end

    def detect_invaders
      cache_manager = SpaceInvadersRadar::MatchesCacheManager.new(radar_sample.width, radar_sample.height)

      invader_patterns.map do |invader_pattern|
        {
          pattern: invader_pattern,
          matches: SpaceInvadersRadar::MatchesCollector.new(
            SpaceInvadersRadar::SlidingWindow.new(radar_sample, invader_pattern),
            SpaceInvadersRadar::Matcher,
            cache_manager,
            accuracy,
            visibility
          ).find_matches
        }
      end
    end

    private

    attr_reader :radar_sample, :invader_patterns, :accuracy, :visibility
  end
end
