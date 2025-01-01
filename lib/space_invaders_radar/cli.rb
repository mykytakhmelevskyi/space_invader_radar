# frozen_string_literal: true

require 'optimist'
require_relative 'file_reader'
require_relative 'grid_data'
require_relative 'invader_pattern'
require_relative 'invaders_detector'
require_relative 'matcher'
require_relative 'matches_cache_manager'
require_relative 'matches_collector'
require_relative 'radar_sample'
require_relative 'sliding_window'

module SpaceInvadersRadar
  # CLI: Command-line interface handler
  class CLI
    def initialize
      parse_options_and_arguments

      validate_arguments
      validate_options
    end

    def run
      radar_sample = SpaceInvadersRadar::RadarSample.new(SpaceInvadersRadar::FileReader.read(radar_file_path))
      invader_patterns = invader_file_paths.map do |file_path|
        SpaceInvadersRadar::InvaderPattern.new(SpaceInvadersRadar::FileReader.read(file_path))
      end

      'cli run output'
    end

    private

    attr_reader :opts, :radar_file_path, :invader_file_paths

    def parse_options_and_arguments
      default_accuracy = SpaceInvadersRadar::MatchesCollector::DEFAULT_ACCURACY
      default_visibility = SpaceInvadersRadar::MatchesCollector::DEFAULT_VISIBILITY

      @opts = Optimist.options do
        banner <<~BANNER
          Usage:
            space_invaders_radar [options] radar_file invader_files...

          Example:
            space_invaders_radar radar_sample.txt invader1.txt invader2.txt --accuracy 0.8 --visibility 0.25
        BANNER
        opt :accuracy, "Set accuracy (default: #{default_accuracy})", type: :float, default: default_accuracy
        opt :visibility, "Set visibility (default: #{default_visibility})", type: :float, default: default_visibility
      end

      @radar_file_path = ARGV.shift
      @invader_file_paths = ARGV
    end

    def validate_arguments
      # Check presence of radar and invader files
      if radar_file_path.nil? || invader_file_paths.empty?
        Optimist.die('You must provide a radar file and at least one invader file.')
      end
    end

    def validate_options
      # Ensure accuracy is within [0, 1]
      if option_out_of_range?(opts[:accuracy])
        Optimist.die(:accuracy, 'must be between 0.0 and 1.0')
      end

      # Ensure visibility is within [0, 1]
      if option_out_of_range?(opts[:visibility])
        Optimist.die(:visibility, 'must be between 0.0 and 1.0')
      end
    end

    def option_out_of_range?(option)
      !option.between?(0.0, 1.0)
    end
  end
end
