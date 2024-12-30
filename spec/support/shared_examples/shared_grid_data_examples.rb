# frozen_string_literal: true

RSpec.shared_examples 'a GridData descendant' do
  let(:instance) { described_class.new(string_data) }

  let(:string_data) { "-o-\no-o\nooo\n" }
  let(:parsed_data) do
    [
      ['-', 'o', '-'],
      ['o', '-', 'o'],
      ['o', 'o', 'o']
    ]
  end

  describe 'Common grid data behavior' do
    it 'sets width attribute' do
      expect(instance.width).to eq(3)
    end

    it 'sets height attribute' do
      expect(instance.height).to eq(3)
    end

    it 'stores data as a 2D array of chars' do
      expect(instance.data).to eq(parsed_data)
    end

    describe '#subsection' do
      subject(:subsection) { instance.subsection(start_x, start_y, width, height) }

      let(:start_x) { 1 }
      let(:start_y) { 1 }
      let(:width) { 2 }
      let(:height) { 2 }

      let(:expectd_subsection) do
        [
          ['-', 'o'],
          ['o', 'o']
        ]
      end

      it 'returns a 2D slice of the data' do
        expect(subsection).to eq(expectd_subsection)
      end
    end
  end
end
