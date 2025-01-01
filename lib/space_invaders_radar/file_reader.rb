# frozen_string_literal: true

module SpaceInvadersRadar
  # FileReader Class
  # This class provides functionality to read a text file, validate that its content starts and ends with a marker,
  # and return the content with the markers stripped. The marker can be customized, with a default value of "~~~".
  class FileReader
    DEFAULT_MARKER = '~~~'

    def self.read(file_path, marker = DEFAULT_MARKER)
      new(file_path, marker).call
    end

    def initialize(file_path, marker)
      @content = read_file(file_path)
      @marker = marker
    end

    def call
      validate_content
      strip_markers
    end

    private

    attr_reader :content, :marker

    def read_file(file_path)
      File.read(file_path)
    rescue Errno::ENOENT
      raise FileNotFoundError, "File not found: #{file_path}"
    end

    def validate_content
      return if content.start_with?(marker) && content.end_with?(marker)

      raise InvalidContentError, "File content must start and end with the marker: #{marker}"
    end

    def strip_markers
      content.lines[1...-1].join
    end

    # Custom exception for file not found errors
    class FileNotFoundError < StandardError; end

    # Custom exception for invalid file content
    class InvalidContentError < StandardError; end
  end
end
