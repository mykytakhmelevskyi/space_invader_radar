# frozen_string_literal: true

RSpec.describe SpaceInvadersRadar::CLI do
  let(:accuracy) { 0.75 }
  let(:visibility) { 0.75 }
  let(:arguments) do
    [
      'radar.txt',
      'invader_1.txt',
      "--accuracy=#{accuracy}",
      "--visibility=#{visibility}"
    ]
  end

  before do
    ARGV.replace(arguments)
  end

  after do
    ARGV.replace([])
  end

  describe '#initialize' do
    subject(:init) { described_class.new }

    it 'initializes without error' do
      expect { init }.not_to raise_error
    end

    context 'when no radar file path provided' do
      let(:arguments) { [] }

      it 'raises an error about missing files' do
        expect { init }
          .to raise_error(SystemExit)
          .and output(/You must provide a radar file and at least one invader file/).to_stderr
      end
    end

    context 'when invalid accuracy is provided' do
      let(:accuracy) { 2.0 }

      it 'raises an error about accuracy' do
        expect { init }
          .to raise_error(SystemExit)
          .and output(/accuracy must be between 0\.0 and 1\.0/).to_stderr
      end
    end

    context 'when invalid visiblity is provided' do
      let(:visibility) { 2.0 }

      it 'raises an error about visiblity' do
        expect { init }
          .to raise_error(SystemExit)
          .and output(/visibility must be between 0\.0 and 1\.0/).to_stderr
      end
    end
  end

  describe '#run' do
    subject(:output) { described_class.new.run }

    let(:radar_path) { 'radar.txt' }
    let(:invader_path) { 'invader_1.txt' }

    let(:arguments) do
      [
        radar_path,
        invader_path,
        '--accuracy=0.85',
        '--visibility=0.75'
      ]
    end

    before do
      allow(SpaceInvadersRadar::FileReader).to receive(:read).with('radar.txt').and_return("--\noo\n")
      allow(SpaceInvadersRadar::FileReader).to receive(:read).with('invader_1.txt').and_return("oo\n")

      ARGV.replace(arguments)
    end

    after do
      ARGV.replace([])
    end

    it 'prints output' do
      expect { output }.not_to raise_error
    end
  end
end
