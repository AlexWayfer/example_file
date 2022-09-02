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

	source_code_uri = 'https://github.com/AlexWayfer/example_file'

	spec.homepage = source_code_uri

	spec.metadata['source_code_uri'] = source_code_uri

	spec.metadata['homepage_uri'] = spec.homepage

	spec.metadata['changelog_uri'] =
		'https://github.com/AlexWayfer/example_file/blob/main/CHANGELOG.md'

	spec.metadata['rubygems_mfa_required'] = 'true'

	spec.files = Dir['lib/**/*.rb', 'README.md', 'LICENSE.txt', 'CHANGELOG.md']

	spec.required_ruby_version = '>= 2.6', '< 4'

	spec.add_runtime_dependency 'diffy', '~> 3.0'
	spec.add_runtime_dependency 'highline', '~> 2.0'
	spec.add_runtime_dependency 'paint', '~> 2.0'

	spec.add_development_dependency 'pry-byebug', '~> 3.9'

	spec.add_development_dependency 'bundler', '~> 2.0'
	spec.add_development_dependency 'bundler-audit', '~> 0.9.0'

	spec.add_development_dependency 'gem_toys', '~> 0.12.1'
	spec.add_development_dependency 'toys', '~> 0.13.0'

	spec.add_development_dependency 'rspec', '~> 3.9'
	spec.add_development_dependency 'simplecov', '~> 0.21.2'
	spec.add_development_dependency 'simplecov-cobertura', '~> 2.1'

	spec.add_development_dependency 'rubocop', '~> 1.36.0'
	spec.add_development_dependency 'rubocop-performance', '~> 1.0'
	spec.add_development_dependency 'rubocop-rspec', '~> 2.0'
end
