# frozen_string_literal: true

require_relative 'example_file/version'

require 'diffy'
require 'highline'
require 'paint'

## Class for example file
class ExampleFile
	SUFFIX = '.example'
	HIGHLINE = HighLine.new

	class << self
		def all(directory)
			Dir[File.join(directory, '**', "*#{SUFFIX}*")]
				.map { |file_name| new file_name }
		end
	end

	def initialize(file_name)
		@file_name = file_name
		@regular_file_name = @file_name.sub SUFFIX, ''

		@basename =
			Paint[File.basename(@file_name), :green, :bold]
		@regular_basename =
			Paint[File.basename(@regular_file_name), :red, :bold]
	end

	def actualize_regular_file
		return create_regular_file unless regular_file_exist?

		return unless updated?

		return update_regular_file if diff.chomp.empty?

		ask_question_and_make_actions
	end

	private

	def updated?
		File.mtime(@file_name) > File.mtime(@regular_file_name)
	end

	def regular_file_exist?
		File.exist? @regular_file_name
	end

	def create_regular_file
		FileUtils.cp @file_name, @regular_file_name
		edit_file @regular_file_name
	end

	def update_regular_file
		FileUtils.touch @regular_file_name
	end

	def diff
		@diff ||= Diffy::Diff
			.new(@regular_file_name, @file_name, source: 'files', context: 3)
			.to_s(:color)
	end

	CHOICES = {
		yes: proc { edit_file @regular_file_name },
		replace: proc { rewrite_regular_file },
		no: proc do
			update_regular_file
			puts 'File modified time updated'
		end
	}.freeze

	private_constant :CHOICES

	def ask_question_and_make_actions
		puts warning_with_diff

		HIGHLINE.choose do |menu|
			menu.layout = :one_line

			menu.prompt = "Do you want to edit #{@regular_basename} ? "

			CHOICES.each do |answer, block|
				menu.choice(answer) { instance_exec(&block) }
			end
		end
	end

	def warning_with_diff
		<<~WARN
			#{@basename} was modified after #{@regular_basename}.

			```diff
			#{diff}
			```

		WARN
	end

	def edit_file(filename)
		abort '`EDITOR` environment variable is empty, see README' if ENV['EDITOR'].to_s.empty?

		system "eval $EDITOR #{filename}"
	end

	def rewrite_regular_file
		File.write @regular_file_name, File.read(@file_name)
	end
end
