# frozen_string_literal: true

module SpaceInvadersRadar
  # SlidingWindow: Represents the current overlap between a radar sample and an invader pattern.
  class SlidingWindow
    attr_reader :overlap_width, :overlap_height, :start_x, :start_y

    def initialize(radar_sample, invader_pattern)
      @radar_sample = radar_sample
      @invader_pattern = invader_pattern
      update_position([-invader_pattern.width, -invader_pattern.height])
    end

    # Returns the current (x, y) position as an array
    def current_position
      [start_x, start_y]
    end

    # Proportion of invader width currently visible in the overlap (0.0..1.0)
    def visible_width_percentage
      visible_percentage(invader_pattern.width, overlap_width)
    end

    # Proportion of invader height currently visible in the overlap (0.0..1.0)
    def visible_height_percentage
      visible_percentage(invader_pattern.height, overlap_height)
    end

    # Sets the sliding window to a new top-left coordinate (x, y) on the radar.
    def update_position(coordinates)
      @start_x, @start_y = coordinates
      @overlap_width = compute_overlap(start_x, invader_pattern.width, radar_sample.width)
      @overlap_height = compute_overlap(start_y, invader_pattern.height, radar_sample.height)
    end

    # Returns the next (x, y) coordinates in a left-to-right, top-to-bottom scan,
    def next_position_coordinates
      # Calculate the next coordinates
      next_x = start_x + 1
      next_y = start_y

      # If we've passed the right boundary, wrap x back to a negative start and move down one row
      if next_x >= radar_sample.width
        next_x = -invader_pattern.width
        next_y += 1
      end

      # Returns empty array if end of the radar sample is reached
      return [] if next_y >= radar_sample.height

      [next_x, next_y]
    end

    # Returns the subsection of the radar sample that overlaps with the invader at the current window position.
    def radar_subsection
      radar_x = [start_x, 0].max
      radar_y = [start_y, 0].max

      radar_sample.subsection(radar_x, radar_y, overlap_width, overlap_height)
    end

    # Returns the subsection of the invader pattern that falls within the radar overlap.
    def invader_pattern_subsection
      # Calculate the invader offsets for the partial overlap
      pattern_x_offset = start_x.negative? ? -start_x : 0
      pattern_y_offset = start_y.negative? ? -start_y : 0

      invader_pattern.subsection(pattern_x_offset, pattern_y_offset, overlap_width, overlap_height)
    end

    private

    attr_reader :radar_sample, :invader_pattern

    # Computes how many columns/rows actually overlap, accounting for negative and out-of-bounds indices.
    def compute_overlap(start, invader_size, radar_size)
      overlap_size = if start.negative?
                       # Pattern extends beyond the left/top edge
                       [invader_size + start, radar_size].min
                     elsif start + invader_size > radar_size
                       # Pattern extends beyond the right/bottom edge
                       [radar_size - start, invader_size].min
                     else
                       # Fully within bounds
                       invader_size
                     end

      # If overlap_size is negative or zero(no overlap), clamp it to 0
      [overlap_size, 0].max
    end

    def visible_percentage(original_size, visible_size)
      (visible_size.to_f / original_size).round(2)
    end
  end
end
