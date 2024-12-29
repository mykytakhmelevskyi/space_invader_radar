# frozen_string_literal: true

module FixturesHelper
  def fixture_path(file_name)
    File.join(
      File.expand_path('../fixtures', __dir__),
      file_name
    )
  end
end
