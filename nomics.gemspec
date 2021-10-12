# frozen_string_literal: true

require_relative "lib/nomics/version"

Gem::Specification.new do |spec|
  spec.name          = "nomics"
  spec.version       = Nomics::VERSION
  spec.authors       = ["Rick Jones"]
  spec.email         = ["rick.jones@playtimestudios.com"]

  spec.summary       = "Nomics"
  spec.description   = "Ruby client for Nomics API"
  spec.required_ruby_version = ">= 3.0.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "typhoeus", "~> 1.4"

  spec.add_development_dependency "pry", "~> 0.14"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.7"
  spec.add_development_dependency "rubocop-rake", "~> 0.6"
  spec.add_development_dependency "rubocop-rspec", "~> 2.5"
  spec.add_development_dependency "webmock", "~> 3.14"
end
