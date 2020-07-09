# frozen_string_literal: true

require_relative 'lib/example_file/version'

Gem::Specification.new do |spec|
	spec.name          = 'example_file'
	spec.version       = ExampleFile::VERSION
	spec.authors       = ['Alexander Popov']
	spec.email         = ['alex.wayfer@gmail.com']

	spec.summary       = 'Class helper for example files'
	spec.description   = <<~DESC
		Class helper for example files.
		Usualy it's the alternative to environment variables (and `.env` files).
		You can have git-controlled example files and git-ignored real files.
		For example, configuration, especially with sensitive data.
	DESC
	spec.license = 'MIT'

	spec.required_ruby_version = '>= 2.5'

	source_code_uri = 'https://github.com/AlexWayfer/example_file'

	spec.homepage = source_code_uri

	spec.metadata['source_code_uri'] = source_code_uri

	spec.metadata['homepage_uri'] = spec.homepage

	# TODO: Put your gem's CHANGELOG.md URL here.
	# spec.metadata["changelog_uri"] = ""

	# Specify which files should be added to the gem when it is released.
	# The `git ls-files -z` loads the files in the RubyGem that have been added
	# into git.
	spec.files = Dir.chdir(__dir__) do
		`git ls-files -z`.split("\x0").reject do |file|
			file.match(%r{^(test|spec|features)/})
		end
	end
	spec.bindir        = 'exe'
	spec.executables   = spec.files.grep(%r{^exe/}) { |file| File.basename(file) }
	spec.require_paths = ['lib']

	spec.add_runtime_dependency 'diffy', '~> 3.0'
	spec.add_runtime_dependency 'highline', '~> 2.0'
	spec.add_runtime_dependency 'paint', '~> 2.0'

	spec.add_development_dependency 'codecov', '~> 0.1.0', '!= 0.1.18', '!= 0.1.19'
	spec.add_development_dependency 'pry-byebug', '~> 3.9'
	spec.add_development_dependency 'rake', '~> 13.0'
	spec.add_development_dependency 'rspec', '~> 3.9'
	spec.add_development_dependency 'rubocop', '~> 0.87.0'
	spec.add_development_dependency 'rubocop-performance', '~> 1.0'
	spec.add_development_dependency 'rubocop-rspec', '~> 1.0'
	spec.add_development_dependency 'simplecov', '~> 0.18.0'
end
