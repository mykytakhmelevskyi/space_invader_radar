# frozen_string_literal: true

RSpec.describe SpaceInvadersRadar::FileReader do
  let(:valid_invader_file_path) { fixture_path('valid_invader.txt') }
  let(:invalid_file_path) { fixture_path('invalid_path.txt') }
  let(:no_marker_path) { fixture_path('invalid_invader_no_markers.txt') }
  let(:custom_marker_file_path) { fixture_path('valid_invader_custom_markers.txt') }
  let(:custom_marker) { nil }

  let(:valid_result) do
    "--o-----o--\n---o---o---\n--ooooooo--\n-oo-ooo-oo-\nooooooooooo\no-ooooooo-o\no-o-----o-o\n---oo-oo---\n"
  end

  describe '#call' do
    subject(:result) { described_class.new(*[file_path, custom_marker].compact).call }

    let(:file_path) { valid_invader_file_path }

    context 'when the file exists and content is valid' do
      it 'returns the content without markers' do
        expect(result).to eq(valid_result)
      end
    end

    context 'when the file does not exist' do
      let(:file_path) { invalid_file_path }

      it 'raises a FileNotFoundError' do
        expect { result }.to raise_error(
          SpaceInvadersRadar::FileReader::FileNotFoundError,
          "File not found: #{invalid_file_path}"
        )
      end
    end

    context 'when the content does not start and end with the marker' do
      let(:file_path) { no_marker_path }

      it 'raises an InvalidContentError' do
        expect { result }.to raise_error(
          SpaceInvadersRadar::FileReader::InvalidContentError,
          'File content must start and end with the marker: ~~~'
        )
      end
    end

    context 'when using a custom marker' do
      let(:custom_marker) { '++' }
      let(:file_path) { custom_marker_file_path }

      it 'strips content correctly with the custom marker' do
        expect(result).to eq(valid_result)
      end
    end
  end
end
