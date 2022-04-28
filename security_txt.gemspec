# frozen_string_literal: true

require_relative "lib/security_txt/version"

Gem::Specification.new do |spec|
  spec.name          = "security_txt"
  spec.version       = SecurityTxt::VERSION
  spec.authors       = ["Joe Stein"]
  spec.email         = ["569991+jas14@users.noreply.github.com"]

  spec.summary       = "A library to generate security.txt files per RFC 9116"
  spec.homepage      = "https://github.com/jas14/security_txt"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/jas14/security_txt/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.11.0"
  spec.add_development_dependency "rubocop", "~> 1.28.2"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
