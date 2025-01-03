# frozen_string_literal: true

module SpaceInvadersRadar
  # OutputHandler:
  # Prints:
  #   1. A summary of each invader pattern with the number of matches (and pattern colorized)
  #   2. A colorized radar sample
  class OutputHandler
    COLORS = [
      "\e[31m", # Red
      "\e[32m", # Green
      "\e[33m", # Yellow
      "\e[34m", # Blue
      "\e[35m", # Magenta
      "\e[36m"  # Cyan
    ].freeze

    RESET = "\e[0m"

    def initialize(results, radar_sample)
      @results = results
      @radar_data = radar_sample.data
    end

    def display
      display_summary
      display_colored_radar
    end

    private

    attr_reader :results, :radar_data

    # Display summary with colorized patterns
    def display_summary
      puts '===== Detection Summary ====='
      results.each_with_index do |result, idx|
        pattern_label = "Pattern ##{idx + 1}"
        match_count = result[:matches].size

        puts "#{pattern_label}: Found #{match_count} matches."
        colorized_rows = colorize_invader_pattern(result[:pattern], color_from_index(idx))
        colorized_rows.each { |row| puts "    #{row}" }
      end
      puts '============================='
    end

    # Display the radar sample with color overlays
    def display_colored_radar
      results.each_with_index do |result, idx|
        color = color_from_index(idx)
        result[:matches].each do |(start_x, start_y)|
          overlay_invader(start_x, start_y, result[:pattern], color)
        end
      end

      puts "\n===== Radar Sample with Detected Invaders ====="
      radar_data.each do |row|
        puts row.join
      end
    end

    # Colorizes 'o' chars in the invader pattern for summary display
    def colorize_invader_pattern(invader_pattern, color)
      inv_data = invader_pattern.data
      inv_data.map do |row|
        row.map do |char|
          char == pattern_char ? colorize_char(char, color) : char
        end.join
      end
    end

    def colorize_char(char, color)
      "#{color}#{char}#{RESET}"
    end

    def color_from_index(index)
      COLORS[index % COLORS.size]
    end

    # Overlays the invader's 'o' cells onto radar_data.
    # If the radar originally had '-', we replace it with 'x'. Otherwise, we keep it as is.
    def overlay_invader(start_x, start_y, invader_pattern, color)
      inv_data = invader_pattern.data

      (0...invader_pattern.height).each do |y|
        (0...invader_pattern.width).each do |x|
          next unless inv_data[y][x] == pattern_char

          radar_x = start_x + x
          radar_y = start_y + y

          # Bounds check
          next if radar_x.negative? || radar_y.negative?
          next if radar_y >= radar_data.size || radar_x >= radar_data[radar_y].size

          # If the original cell was '-', replace it with 'x'
          current_char = radar_data[radar_y][radar_x]
          current_char = 'x' if current_char != pattern_char

          radar_data[radar_y][radar_x] = colorize_char(current_char, color)
        end
      end
    end

    def pattern_char
      SpaceInvadersRadar::InvaderPattern::DEFAULT_PATTERN_CHAR
    end
  end
end

