# frozen_string_literal: true

RSpec.describe SpaceInvadersRadar::SlidingWindow do
  let(:radar_data) do
    <<~RADAR
      -----
      o-oo-
      ----o
      -----
    RADAR
  end

  let(:invader_data) do
    <<~INVADER
      o-
      -o
    INVADER
  end

  let(:radar_sample)    { SpaceInvadersRadar::RadarSample.new(radar_data) }
  let(:invader_pattern) { SpaceInvadersRadar::InvaderPattern.new(invader_data) }

  let(:instance) { described_class.new(radar_sample, invader_pattern) }

  let(:init_x) { -2 }
  let(:init_y) { -2 }

  describe '#initialize' do
    it 'sets the starting position to negative invader width' do
      expect(instance.start_x).to eq(init_x)
    end

    it 'sets the starting position to negative invader height' do
      expect(instance.start_y).to eq(init_y)
    end

    it 'computes initial overlap_width as 0' do
      expect(instance.overlap_width).to eq(0)
    end

    it 'computes initial overlap_height as 0' do
      expect(instance.overlap_height).to eq(0)
    end
  end

  describe '#current_position' do
    subject(:current_position) { instance.current_position }

    it 'returns the current position in form of an array of coordinates' do
      expect(current_position).to eq([init_x, init_y])
    end
  end

  describe '#visible_width_percentage' do
    subject(:visible_width_percentage) { instance.visible_width_percentage }

    let(:init_x) { -1 }
    let(:init_y) { 1 }

    before do
      instance.update_position([init_x, init_y])
    end

    context 'when the half of the invader is visible over the left border' do
      it 'returns percentage of the invader pattern width that is visible' do
        expect(visible_width_percentage).to eq(0.5)
      end
    end
  end

  describe '#visible_height_percentage' do
    subject(:visible_height_percentage) { instance.visible_height_percentage }

    let(:init_x) { 1 }
    let(:init_y) { -1 }

    before do
      instance.update_position([init_x, init_y])
    end

    context 'when the half of the invader is visible over the top border' do
      it 'returns percentage of the invader pattern height that is visible' do
        expect(visible_height_percentage).to eq(0.5)
      end
    end
  end

  describe '#update_position' do
    subject(:update_position) { instance.update_position([new_x, new_y]) }

    let(:new_x) { 4 }
    let(:new_y) { 2 }

    it 'updates start_x to the given x' do
      expect { update_position }.to change { instance.start_x }.from(init_x).to(new_x)
    end

    it 'updates start_y to the given y' do
      expect { update_position }.to change { instance.start_y }.from(init_y).to(new_y)
    end

    it 'computes and sets overlap_width based on the radar/pattern overlap' do
      expect { update_position }.to change { instance.overlap_width }.from(0).to(1)
    end

    it 'computes and sets overlap_height based on the radar/pattern overlap' do
      expect { update_position }.to change { instance.overlap_height }.from(0).to(2)
    end
  end

  describe '#next_position_coordinates' do
    subject(:next_position_coordinates) { instance.next_position_coordinates }

    let(:new_x) { init_x }
    let(:new_y) { init_y }

    before do
      instance.update_position([new_x, new_y])
    end

    it 'returns next position coordinates where x is incremented by 1' do
      expect(next_position_coordinates).to eq([init_x + 1, init_y])
    end

    context 'when x goes beyond the right boundary' do
      let(:new_x) { 4 }

      it 'returns next position coordinates for the begining of the next line' do
        expect(next_position_coordinates).to eq([init_x, init_y + 1])
      end
    end

    context 'when y goes beyond the bottom boundary' do
      let(:new_x) { 4 }
      let(:new_y) { 3 }

      it 'returns empty array' do
        expect(next_position_coordinates).to eq([])
      end
    end
  end

  describe '#radar_subsection' do
    subject(:radar_subsection) { instance.radar_subsection }

    let(:new_x) { init_x }
    let(:new_y) { init_y }

    let(:radar_x) { 0 }
    let(:radar_y) { 0 }
    let(:overlap_width) { 0 }
    let(:overlap_height) { 0 }

    before do
      instance.update_position([new_x, new_y])

      allow(radar_sample).to receive(:subsection)
                         .with(radar_x, radar_y, overlap_width, overlap_height)
    end

    it 'calls subsection method on radar sample instance with initial parameters' do
      radar_subsection

      expect(radar_sample).to have_received(:subsection)
                          .with(radar_x, radar_y, overlap_width, overlap_height).once
    end

    context 'when invader pattern is partially visible' do
      let(:new_x) { 4 }
      let(:new_y) { 2 }

      let(:radar_x) { new_x }
      let(:radar_y) { new_y }
      let(:overlap_width) { 1 }
      let(:overlap_height) { 2 }

      it 'calls subsection method on radar sample instance with appropriate args' do
        radar_subsection

        expect(radar_sample).to have_received(:subsection)
                            .with(radar_x, radar_y, overlap_width, overlap_height).once
      end
    end
  end

  describe '#invader_pattern_subsection' do
    subject(:invader_pattern_subsection) { instance.invader_pattern_subsection }

    let(:new_x) { init_x }
    let(:new_y) { init_y }

    let(:pattern_x_offset) { 2 }
    let(:pattern_y_offset) { 2 }
    let(:overlap_width) { 0 }
    let(:overlap_height) { 0 }

    before do
      instance.update_position([new_x, new_y])

      allow(invader_pattern).to receive(:subsection)
                            .with(pattern_x_offset, pattern_y_offset, overlap_width, overlap_height)
    end

    it 'calls subsection method on invader pattern instance with initial parameters' do
      invader_pattern_subsection
      expect(invader_pattern).to have_received(:subsection)
                             .with(pattern_x_offset, pattern_y_offset, overlap_width, overlap_height).once
    end

    context 'when invader pattern is partially visible over left border' do
      let(:new_x) { -1 }
      let(:new_y) { 0 }

      let(:pattern_x_offset) { 1 }
      let(:pattern_y_offset) { 0 }
      let(:overlap_width) { 1 }
      let(:overlap_height) { 2 }

      it 'calls subsection method on invader pattern instance with appropriate args' do
        invader_pattern_subsection
        expect(invader_pattern).to have_received(:subsection)
                               .with(pattern_x_offset, pattern_y_offset, overlap_width, overlap_height).once
      end
    end

    context 'when invader pattern is partially visible over bottom border' do
      let(:new_x) { 1 }
      let(:new_y) { 3 }

      let(:pattern_x_offset) { 0 }
      let(:pattern_y_offset) { 0 }
      let(:overlap_width) { 2 }
      let(:overlap_height) { 1 }

      it 'calls subsection method on invader pattern instance with appropriate args' do
        invader_pattern_subsection
        expect(invader_pattern).to have_received(:subsection)
                               .with(pattern_x_offset, pattern_y_offset, overlap_width, overlap_height).once
      end
    end
  end
end
