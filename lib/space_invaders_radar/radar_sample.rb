# frozen_string_literal: true

module SpaceInvadersRadar
  # RadarSample: Represents the radar sample
  class RadarSample
    attr_reader :sample, :width, :height

    def initialize(string_data)
      @sample = string_data.split("\n")
      @height = sample.size
      @width = sample[0].size
    end
  end
end
