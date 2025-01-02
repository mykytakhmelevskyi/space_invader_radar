# frozen_string_literal: true

RSpec.describe SpaceInvadersRadar::MatchesCollector do
  subject(:find_matches) { collector.find_matches }

  let(:collector) do
    described_class.new(
      sliding_window,
      matcher,
      cache_manager,
      accuracy,
      visibility
    )
  end

  let(:sliding_window) { instance_double(SpaceInvadersRadar::SlidingWindow) }
  let(:matcher) { class_double(SpaceInvadersRadar::Matcher) }
  let(:cache_manager) { instance_double(SpaceInvadersRadar::MatchesCacheManager) }

  let(:accuracy) { 0.8 }
  let(:visibility) { 0.25 }

  let(:new_x) { 0 }
  let(:new_y) { 0 }
  let(:new_coordinates) { [new_x, new_y] }
  let(:next_position_coordinates) { new_coordinates }
  let(:second_position_coordinates) { [] }
  let(:overlaps_cached_area?) { false }
  let(:visible_width_percentage) { 1.0 }
  let(:visible_height_percentage) { 1.0 }
  let(:invader_pattern_subsection) { [%w[o]] }
  let(:radar_subsection) { [%w[o]] }
  let(:similarity_score) { 1.0 }

  before do
    allow(sliding_window).to receive_messages(
      start_x: new_x,
      start_y: new_y,
      visible_width_percentage: visible_width_percentage,
      visible_height_percentage: visible_height_percentage,
      invader_pattern_subsection: invader_pattern_subsection,
      radar_subsection: radar_subsection,
      current_position: new_coordinates
    )
    allow(sliding_window).to receive(:next_position_coordinates)
                         .and_return(next_position_coordinates, second_position_coordinates)
    allow(sliding_window).to receive(:update_position).with(new_coordinates)

    allow(matcher).to receive(:compare)
      .with(invader_pattern_subsection, radar_subsection)
      .and_return(similarity_score)

    allow(cache_manager).to receive(:overlaps_cached_area?).and_return(overlaps_cached_area?)
    allow(cache_manager).to receive(:cache_section).with(new_x, new_y, invader_pattern_subsection)
  end

  it 'returns matches with the current coordinates' do
    expect(find_matches).to eq([new_coordinates])
  end

  context 'when next_position_coordinates is empty immediately' do
    let(:next_position_coordinates) { [] }

    it 'returns an empty array' do
      expect(find_matches).to eq([])
    end
  end

  context 'when current area overlaps cached area' do
    let(:overlaps_cached_area?) { true }

    it 'does not add a match' do
      expect(find_matches).to eq([])
    end
  end

  context 'when visible_width_percentage or visible_height_percentage is below threshold' do
    let(:visible_width_percentage)  { 0.1 }
    let(:visible_height_percentage) { 1.0 }

    it 'does not add a match' do
      expect(find_matches).to eq([])
    end
  end

  context 'when similarity score is below accuracy' do
    let(:similarity_score) { 0.5 }

    it 'does not add a match' do
      expect(find_matches).to eq([])
    end
  end
end
