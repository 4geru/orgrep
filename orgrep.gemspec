# frozen_string_literal: true

require_relative "lib/orgrep/version"

Gem::Specification.new do |spec|
  spec.name = "orgrep"
  spec.version = Orgrep::VERSION
  spec.authors = ["4geru"]
  spec.email = ["westhouse51@gmail.com"]

  spec.summary = "git clone and git grep on the latest repository"
  spec.description = "git clone and git grep on the latest repository"
  spec.homepage = "https://github.com/4geru/orgrep"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org/gems/omniauth-himari/orgrep"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/4geru/orgrep"
  spec.metadata["changelog_uri"] = "https://github.com/4geru/orgrep/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "dotenv", "~> 2.8"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
