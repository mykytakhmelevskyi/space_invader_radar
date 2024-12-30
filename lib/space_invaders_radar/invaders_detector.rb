# frozen_string_literal: true

module SpaceInvadersRadar
  # InvadersDetector:
  # This class is responsible for analyzing a radar sample against multiple invader patterns.
  # It uses a Matcher instance for each pattern, applying configurable accuracy and visibility
  # thresholds. The result is a collection of detected matches for each invader.
  class InvadersDetector
    attr_reader :radar_sample, :invader_patterns, :accuracy, :visibility

    def initialize(radar_sample, invader_patterns, accuracy, visibility)
      @radar_sample = radar_sample
      @invader_patterns = invader_patterns
      @accuracy = accuracy
      @visibility = visibility
    end
  end
end
