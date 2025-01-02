# frozen_string_literal: true

module SpaceInvadersRadar
  # MatchesCollector:
  # Responsible for scanning the radar and finding all occurrences of an InvaderPattern.
  class MatchesCollector
    DEFAULT_ACCURACY = 0.8
    DEFAULT_VISIBILITY = 0.25

    attr_reader :matches

    def initialize(sliding_window, matcher, cache_manager, accuracy = DEFAULT_ACCURACY, visibility = DEFAULT_VISIBILITY)
      @accuracy = accuracy
      # We treat `visibility` as an area fraction, so we approximate side-visibility by sqrt(visibility)
      @side_visibility_percentage = Math.sqrt(visibility).round(2)

      @sliding_window = sliding_window
      @matcher = matcher
      @cache_manager = cache_manager

      @matches = []
    end

    def find_matches
      loop do
        next_position_coordinates = sliding_window.next_position_coordinates

        break if next_position_coordinates.empty?

        sliding_window.update_position(next_position_coordinates)

        next if subsection_is_cached?
        next if invader_not_visible_enough?

        if sliding_window_contains_invader?
          store_current_match_position
          cache_match
        end
      end

      matches
    end

    private

    attr_reader :accuracy, :side_visibility_percentage, :sliding_window, :matcher, :cache_manager

    def store_current_match_position
      matches << sliding_window.current_position
    end

    def subsection_is_cached?
      cache_manager.overlaps_cached_area?(
        sliding_window.start_x,
        sliding_window.start_y,
        sliding_window.invader_pattern_subsection
      )
    end

    def cache_match
      cache_manager.cache_section(
        sliding_window.start_x,
        sliding_window.start_y,
        sliding_window.invader_pattern_subsection
      )
    end

    def invader_not_visible_enough?
      sliding_window.visible_width_percentage < side_visibility_percentage ||
        sliding_window.visible_height_percentage < side_visibility_percentage
    end

    def sliding_window_contains_invader?
      matcher.compare(sliding_window.invader_pattern_subsection, sliding_window.radar_subsection) >= accuracy
    end
  end
end
