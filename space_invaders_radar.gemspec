# frozen_string_literal: true

require_relative "lib/space_invaders_radar/version"

Gem::Specification.new do |spec|
  spec.name = "space_invaders_radar"
  spec.version = SpaceInvadersRadar::VERSION
  spec.authors = ["Mykyta Khmelevskyi"]
  spec.email = ["mykyta.khmelevskyi@gmail.com"]

  spec.summary = "Detect invaders in radar samples."
  spec.description = "A Ruby gem for detecting invader patterns in radar data."
  spec.homepage = "TODO: Put your gem's website or public repo URL here."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end