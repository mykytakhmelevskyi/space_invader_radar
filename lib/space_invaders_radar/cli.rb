# frozen_string_literal: true

require 'optimist'
require_relative 'invaders_detector'
require_relative 'file_reader'
require_relative 'invader_pattern'
require_relative 'radar_sample'

module SpaceInvadersRadar
  # CLI: Command-line interface handler
  class CLI
    def initialize
      # Parse and validate CLI arguments
      @opts = Optimist.options do
        banner <<~BANNER
          Usage:
            space_invaders_radar [options] radar_file invader_files...

          Example:
            space_invaders_radar radar_sample.txt invader1.txt invader2.txt --accuracy 0.8 --visibility 0.25
        BANNER
        opt :accuracy, 'Set accuracy (default: 0.8)', type: :float, default: 0.8
        opt :visibility, 'Set visibility (default: 0.25)', type: :float, default: 0.25
      end

      @radar_file_path = ARGV.shift
      @invader_file_paths = ARGV
      validate_arguments
    end

    def run
      radar_sample = SpaceInvadersRadar::RadarSample.new(FileReader.read(@radar_file_path))
      invader_patterns = @invader_file_paths.map do |file_path|
        SpaceInvadersRadar::InvaderPattern.new(FileReader.read(file_path))
      end

      'cli run output'
    end

    private

    def validate_arguments
      # Check presence of radar and invader files
      if @radar_file_path.nil? || @invader_file_paths.empty?
        Optimist.die('You must provide a radar file and at least one invader file.')
      end

      # Ensure accuracy is within [0, 1]
      if option_out_of_range?(@opts[:accuracy])
        Optimist.die(:accuracy, 'must be between 0.0 and 1.0')
      end

      # Ensure visibility is within [0, 1]
      if option_out_of_range?(@opts[:visibility])
        Optimist.die(:visibility, 'must be between 0.0 and 1.0')
      end
    end

    def option_out_of_range?(option)
      !option.between?(0.0, 1.0)
    end
  end
end
