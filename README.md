# Example File

![Cirrus CI - Base Branch Build Status](https://img.shields.io/cirrus/github/AlexWayfer/example_file?style=flat-square)
[![Codecov branch](https://img.shields.io/codecov/c/github/AlexWayfer/example_file/master.svg?style=flat-square)](https://codecov.io/gh/AlexWayfer/example_file)
[![Code Climate](https://img.shields.io/codeclimate/maintainability/AlexWayfer/example_file.svg?style=flat-square)](https://codeclimate.com/github/AlexWayfer/example_file)
![Depfu](https://img.shields.io/depfu/AlexWayfer/example_file?style=flat-square)
[![Inline docs](https://inch-ci.org/github/AlexWayfer/example_file.svg?branch=master)](https://inch-ci.org/github/AlexWayfer/example_file)
[![license](https://img.shields.io/github/license/AlexWayfer/example_file.svg?style=flat-square)](https://github.com/AlexWayfer/example_file/blob/master/LICENSE)
[![Gem](https://img.shields.io/gem/v/example_file.svg?style=flat-square)](https://rubygems.org/gems/example_file)

Class helper for example files. Usualy it's the alternative
to environment variables (and `.env` files).

You can have git-controlled example files and git-ignored real files.
For example, configuration, especially with sensitive data.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'example_file'
```

And then execute:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install example_file
```

## Usage

```ruby
require 'example_file'

ExampleFile.new('some_file.example.conf').actualize_regular_file
```

For `some_file.example.conf` example file there is `some_file.conf`
regular file.

Editor below is `$EDITOR` environment variable.
You should set it to your preferred editor, console or GUI
(console is more comfortable usually for such scenarios).

It'll act in these ways:

*   If there is no regular file:
    *   create it with content from example and open the editor.
*   If there is example file with file modified time after regular file:
    *   If there is no difference between their contents:
        *   touch regular file for updating its modified time.
    *   If there is a difference between their contents:
        *   ask for a further action:
            *   open the editor;
            *   just update regular without changes;
            *   or replace regular file with a content from new example file.
*   If there is regular file with file modified time after example file:
    *   do nothing.

You should add example files to git control:

```shell
git add some_file.example.conf
```

And ignore regular ones in `.gitignore`:

```gitignore
some_file.conf
```

Recursively it'd be like:

```gitignore
config/**/*
!config/**/*.example*
```

## Development

After checking out the repo, run `bundle install` to install dependencies.

Then, run `toys rspec` to run the tests.

To install this gem onto your local machine, run `toys gem install`.

To release a new version, run `toys gem release %version%`.
See how it works [here](https://github.com/AlexWayfer/gem_toys#release).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/AlexWayfer/example_file).

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
