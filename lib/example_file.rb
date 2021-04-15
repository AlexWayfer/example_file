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

	attr_reader :choices
	attr_writer :question_prefix

	def initialize(file_name)
		@file_name = file_name
		@regular_file_name = @file_name.sub SUFFIX, ''

		@basename = Paint[File.basename(@file_name), :green, :bold]
		@regular_basename = Paint[File.basename(@regular_file_name), :red, :bold]

		@choices = DEFAULT_CHOICES.dup
		@question_prefix = nil
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

	DEFAULT_CHOICES = {
		edit: proc { edit_file @regular_file_name },
		replace: proc { rewrite_regular_file },
		'replace-and-edit': proc do
			rewrite_regular_file
			edit_file @regular_file_name
		end,
		keep: proc do
			update_regular_file
			puts 'File modified time updated'
		end
	}.freeze

	private_constant :DEFAULT_CHOICES

	def ask_question_and_make_actions
		puts warning_with_diff

		HIGHLINE.choose do |menu|
			## I don't know how to catch complex options like `replace-and-edit`, via shortcut like `rae`
			# menu.layout = :one_line

			menu.header = "What to do with #{@regular_basename} "

			choices.each do |answer, block|
				menu.choice(answer) { instance_exec(&block) }
			end
		end
	end

	def warning_with_diff
		<<~WARN
			#{@question_prefix}#{@basename} was modified after #{@regular_basename}.

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
