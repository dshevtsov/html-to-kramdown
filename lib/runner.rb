require_relative 'reader'
require_relative 'writer'
require_relative 'options'
require_relative 'crawler'
require 'find'

module HtmlToKramdown
  # The main class that runs the conversion
  class Runner
    attr_reader :path, :args

    def initialize(args)
      @args = args
    end

    EXTENSIONS = ['.md'].freeze

    def run
      # Parse CLI options
      @options = Options.parse(args)
      # After the parsing only the ARGV[0] (firtst argument in the CLI) remains in the arrray.
      # Convert the path to String to use with Find.find
      path = args.join
      Find.find(path) do |item|
        puts "Starting with #{item} ..."
        if FileTest.file?(item)
          puts 'Reading extension ...'
          if EXTENSIONS.include? File.extname(item)
            puts 'Reading the file ...'
            go(item)
            puts 'Done'
          else
            puts "#{File.extname(item)} - skipped"
            next
          end
        else
          puts 'not a file.'
        end
      end
    end

    def go(file)
      if @options.links
        @content = reader.all(file)
        converted_content = crawler.links_to_kramdown(@content)
        write(file, converted_content)
      elsif @options.images
        @content = reader.all(file)
        converted_content = crawler.images_to_kramdown(@content)
        write(file, converted_content)
      elsif @options.tables
        @content = reader.all(file)
        converted_content = crawler.tables_to_kramdown(@content)
        write(file, converted_content)
      elsif @options.headings
        @content = reader.all(file)
        converted_content = crawler.headings_to_kramdown(@content)
        write(file, converted_content)
      end
    end

    def write(file, content)
      writer.from_string(file, content)
    end

    def reader
      Reader.new
    end

    def writer
      Writer.new
    end

    def crawler
      Crawler.new
    end
  end
end
