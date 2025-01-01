# frozen_string_literal: true

module SpaceInvadersRadar
  # Matcher: Implements Jaccard Index (Intersection over Union) algorithm
  # Handles Noise:
  # - The Jaccard Index is robust to both false positives (extra noise in the radar sample)
  #   and false negatives (missing parts of the pattern).
  # - It balances these issues by focusing on the overlap (intersection) relative
  #   to the union of the pattern and the sample.
  # Pattern Detection:
  # - Since the problem involves ASCII patterns, the Jaccard Index can measure similarity
  #   effectively by quantifying how much of the pattern is matched.
  class Matcher
    def self.compare(invader_pattern_subsection, radar_subsection,
                     pattern_char = SpaceInvadersRadar::InvaderPattern::DEFAULT_PATTERN_CHAR)
      intersection = 0
      union = 0

      invader_pattern_subsection.each_with_index do |row, i|
        row.each_with_index do |invader_char, j|
          radar_char = radar_subsection[i][j]
          union += 1 if invader_char == pattern_char || radar_char == pattern_char
          intersection += 1 if invader_char == pattern_char && radar_char == pattern_char
        end
      end
      return 0.0 if union.zero?

      (intersection.to_f / union).round(2)
    end
  end
end
