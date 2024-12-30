# frozen_string_literal: true

RSpec.describe SpaceInvadersRadar::InvaderPattern do
  it_behaves_like 'a GridData descendant'

  it "has a default pattern char constant of 'o'" do
    expect(described_class::DEFAULT_PATTERN_CHAR).to eq('o')
  end
end
