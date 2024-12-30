# frozen_string_literal: true

module SpaceInvadersRadar
  # GridData: A base class for 2D grid-like data
  class GridData
    attr_reader :data, :width, :height

    def initialize(string_data)
      @data = string_data.split("\n").map(&:chars)
      @height = data.size
      @width = data.any? ? data[0].size : 0
    end

    # Returns a slice of the grid at (x, y) with the given width & height
    def subsection(x, y, width, height)
      @data[y...(y + height)].map { |row| row[x...(x + width)] }
    end
  end
end
