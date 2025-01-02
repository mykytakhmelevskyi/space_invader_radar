# frozen_string_literal: true

module SpaceInvadersRadar
  # MatchesCacheManager:
  #
  # Implements a 2D bitmap for the radar grid to track which cells are already
  # "occupied" or "cached"
  class MatchesCacheManager
    attr_reader :cache_map

    def initialize(radar_width, radar_height)
      # 2D array of booleans, default false (not cached)
      @cache_map = Array.new(radar_height) { Array.new(radar_width, false) }
    end

    def overlaps_cached_area?(start_x, start_y, pattern_subsection)
      pattern_subsection.each_with_index do |row, pattern_y|
        row.each_with_index do |char, pattern_x|
          next unless char == SpaceInvadersRadar::InvaderPattern::DEFAULT_PATTERN_CHAR

          return true if cache_map[start_y + pattern_y][start_x + pattern_x]
        end
      end
      false
    end

    # Marks every invader pattern character in the pattern_subsection as true in the bitmap.
    def cache_section(start_x, start_y, pattern_subsection)
      pattern_subsection.each_with_index do |row, pattern_y|
        row.each_with_index do |char, pattern_x|
          next unless char == SpaceInvadersRadar::InvaderPattern::DEFAULT_PATTERN_CHAR

          cache_map[start_y + pattern_y][start_x + pattern_x] = true
        end
      end
    end
  end
end
