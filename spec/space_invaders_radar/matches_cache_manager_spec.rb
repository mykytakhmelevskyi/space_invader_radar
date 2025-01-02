# frozen_string_literal: true

RSpec.describe SpaceInvadersRadar::MatchesCacheManager do
  let(:radar_width)  { 5 }
  let(:radar_height) { 5 }
  let(:cache_manager) { described_class.new(radar_width, radar_height) }

  let(:pattern_subsection) do
    [
      ['o', '-'],
      ['-', 'o']
    ]
  end

  describe '#overlaps_cached_area?' do
    subject(:overlaps_cached_area?) { cache_manager.overlaps_cached_area?(start_x, start_y, pattern_subsection) }

    let(:start_x) { 1 }
    let(:start_y) { 1 }

    context 'when no cells have been cached' do
      it 'returns false even if the pattern_subsection has "o"' do
        expect(overlaps_cached_area?).to eq(false)
      end
    end

    context 'when matching cells are already cached' do
      before do
        cache_manager.cache_section(start_x, start_y, pattern_subsection)
      end

      it 'returns true for overlapping "o" cells' do
        expect(overlaps_cached_area?).to eq(true)
      end
    end

    context 'when there is no cached pattern in the area' do
      let(:start_x) { -1 }
      let(:start_y) { -1 }

      it 'returns false' do
        expect(overlaps_cached_area?).to eq(false)
      end
    end

    context 'when there is at least one cached cell in the overlapped area' do
      before do
        cache_manager.cache_section(1, 1, [['o']])
      end

      it 'returns true' do
        expect(overlaps_cached_area?).to eq(true)
      end
    end
  end

  describe '#cache_section' do
    subject(:cache_section) { cache_manager.cache_section(start_x, start_y, pattern_subsection) }

    let(:start_x) { 1 }
    let(:start_y) { 1 }
    
    it 'caches all "o" cells' do
      expect { cache_section }.to change { cache_manager.cache_map[1][1] }.from(false).to(true)
                              .and change { cache_manager.cache_map[2][2] }.from(false).to(true)
    end
  end
end
