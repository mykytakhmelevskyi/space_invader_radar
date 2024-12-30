# frozen_string_literal: true

module SpaceInvadersRadar
  # InvaderPattern: Represents the invader pattern
  class InvaderPattern
    attr_reader :pattern, :width, :height, :size

    def initialize(string_data)
      @pattern = string_data.split("\n")
      @height = pattern.size
      @width = pattern[0].size
      @size = height * width
    end
  end
end
