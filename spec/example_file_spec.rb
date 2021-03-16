# frozen_string_literal: true

describe ExampleFile do
	let(:instance) { described_class.new(file_name) }
	let(:fixtures_dir) { "#{__dir__}/fixtures" }

	before do
		allow(ENV).to receive(:[]).and_call_original
		allow(ENV).to receive(:[]).with('EDITOR').and_return('nano')
	end

	describe '.all' do
		subject { described_class.all(fixtures_dir) }

		describe 'classes of elements' do
			subject { super().map(&:class).uniq }

			it { is_expected.to eq [described_class] }
		end
	end

	describe '#actualize_regular_file' do
		shared_context 'with EDITOR evaluation' do
			before do
				allow(instance).to receive(:system).with(start_with('eval $EDITOR')) do
					File.write regular_file_name, new_regular_file_content
				end
			end
		end

		shared_examples 'files mtime comparison' do
			describe 'comparison regular file mtime and example file mtime' do
				let(:class_for_description) { superclass_for_description }

				include_context 'with EDITOR evaluation'

				before do
					instance.actualize_regular_file
				end

				it { expect(regular_file_mtime).to be > example_file_mtime }
			end
		end

		shared_examples 'files content comparison' do |is_equal, value_method = :example_file_content|
			describe 'comparison regular file content and example file content' do
				let(:class_for_description) { superclass_for_description }

				include_context 'with EDITOR evaluation'

				before do
					instance.actualize_regular_file
				end

				it do
					expect(regular_file_content).public_send(
						is_equal ? :to : :not_to, eq(send(value_method))
					)
				end
			end
		end

		shared_examples 'regular file edited in editor' do
			let(:new_regular_file_content) { '3' }

			context 'when $EDITOR variable exists' do
				include_context 'with EDITOR evaluation'

				include_examples 'files content comparison', true, :new_regular_file_content
			end

			context 'when $EDITOR variable not set' do
				let(:abort_text) { '`EDITOR` environment variable is empty, see README' }

				before do
					allow(ENV).to receive(:[]).with('EDITOR').and_return(nil)

					allow(instance).to receive(:abort).with(abort_text).and_call_original.once
				end

				it do
					expect { instance.actualize_regular_file }.to raise_error(SystemExit)
						.and output("#{abort_text}\n").to_stderr
				end
			end
		end

		def build_example_description(example_class)
			example_description = example_class.description
			return if example_description.start_with?('#')

			[send(__method__, example_class.superclass), example_description]
				.flatten.compact.join('/')
		end

		let(:class_for_description) { self.class }
		let(:superclass_for_description) { self.class.superclass }
		let(:example_description) do
			build_example_description class_for_description
		end
		let(:file_name) do
			file_name_parts = example_description.split
			file_name_parts.delete('when')
			result = file_name_parts.join('_')
			Dir["#{fixtures_dir}/#{result}.example*"].first
		end
		let(:regular_file_name) { file_name.sub('.example', '') }

		let(:example_file_mtime) { File.mtime(file_name) }
		let(:regular_file_mtime) { File.mtime(regular_file_name) }

		let(:example_file_content) { File.read(file_name) }
		let(:regular_file_content) { File.read(regular_file_name) }

		context 'when file without regular' do
			after do
				FileUtils.rm regular_file_name
			end

			include_examples 'files mtime comparison'

			include_examples 'regular file edited in editor'
		end

		context 'when file with actual regular' do
			before do
				FileUtils.touch regular_file_name
			end

			include_examples 'files mtime comparison'
		end

		context 'when file with outdated regular' do
			before do
				FileUtils.touch file_name
				## For difference between this touch and actualization
				sleep 0.1
			end

			context 'with same content' do
				include_examples 'files mtime comparison'
			end

			context 'with different content' do
				root_superclass = self
				let(:class_for_description) { root_superclass }
				let(:superclass_for_description) { root_superclass }

				let(:stylized_regular_file_name) do
					Paint[File.basename(regular_file_name), :red, :bold]
				end

				before do
					allow($stdout).to receive(:puts).with <<~WARN
						#{Paint[File.basename(file_name), :green, :bold]} was modified after #{stylized_regular_file_name}.

						```diff
						#{Paint['-1', :red]}
						#{Paint['+2', :green]}

						```

					WARN

					allow($stdout).to receive(:write).with <<~QUESTION.chomp
						What do you want to do with #{stylized_regular_file_name} ? (edit, replace or keep) \

					QUESTION

					allow($stdin).to receive(:eof?).and_return(false)
					allow($stdin).to receive(:gets).and_return(answer)
				end

				context 'when answer is `edit`' do
					let(:answer) { 'edit' }

					around do |example|
						old_regular_file_name_content = File.read regular_file_name
						example.run
						File.write regular_file_name, old_regular_file_name_content
						## For next tests with touching example file
						sleep 0.1
					end

					include_examples 'files mtime comparison'

					include_examples 'regular file edited in editor'
				end

				context 'when answer is `replace`' do
					let(:answer) { 'replace' }

					around do |example|
						old_regular_file_name_content = File.read regular_file_name
						example.run
						File.write regular_file_name, old_regular_file_name_content
						## For next tests with touching example file
						sleep 0.1
					end

					include_examples 'files mtime comparison'
					include_examples 'files content comparison', true
				end

				context 'when answer is `keep`' do
					let(:answer) { 'keep' }

					before do
						allow($stdout).to receive(:puts).with('File modified time updated')
					end

					include_examples 'files mtime comparison'

					describe 'file content' do
						it do
							instance.actualize_regular_file
							expect(regular_file_content).not_to eq example_file_content
						end
					end
				end
			end
		end
	end
end
