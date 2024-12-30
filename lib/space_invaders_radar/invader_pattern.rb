# frozen_string_literal: true

module SpaceInvadersRadar
  # InvaderPattern: Represents the invader pattern
  class InvaderPattern < SpaceInvadersRadar::GridData
    DEFAULT_PATTERN_CHAR = 'o'

    attr_reader :size

    def initialize(string_data)
      super
      @size = height * width
    end
  end
end
