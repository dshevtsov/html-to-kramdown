require 'optparse'
require 'pp'

module HtmlToKramdown
  # CLI option parser
  class Options
    VERSION = '5'.freeze
    # CLI options initialization
    class ScriptOptions
      attr_accessor :links, :tables, :images, :headings, :notes, :help, :notes_html, :notes_html_md

      def initialize
        self.links = false
        self.tables = false
        self.images = false
        self.headings = false
        self.notes = false
        self.notes_html = false
        self.notes_html_md = false
      end
    end

    def self.parse(args)
      # Collect the options specified on the command line in *options*.
      @options = ScriptOptions.new
      option_parser.parse! args
      @options
    end

    attr_reader :parser, :options

    def self.option_parser
      @parser ||= OptionParser.new do |parser|
        parser.banner = 'Usage: html-to-kramdown PATH options '
        parser.separator ''
        parser.separator 'Example: html-to-kramdown /Users/user/docs --links '
        parser.separator ''
        parser.separator 'Specific options:'

        # Add custom options.
        links_option parser
        headings_option parser
        images_option parser
        tables_option parser
        notes_option parser
        notes_html_option parser
        notes_with_md_option parser

        parser.separator ''
        parser.separator 'Common options:'
        # Print options summary.
        parser.on_tail('-h', '--help', 'Show this message') do
          puts parser
          exit
        end

        # Typical switch to print the version.
        parser.on_tail('-v', '--version', 'Show version') do
          puts VERSION
          exit
        end
      end
    end

    def self.links_option(parser)
      parser.on('-l', '--links', 'Convert HTML links in the .md files in the given path recursively.') do |l|
        @options.links = l
      end
    end

    def self.images_option(parser)
      parser.on('-i', '--images', 'Convert HTML images in the .md files in the given path recursively.') do |i|
        @options.images = i
      end
    end

    def self.headings_option(parser)
      parser.on('-h', '--headings', 'Convert HTML headings in the .md files in the given path recursively.') do |h|
        @options.headings = h
      end
    end

    def self.tables_option(parser)
      parser.on('-t', '--tables', 'Convert HTML tables in the .md files in the given path recursively.') do |t|
        @options.tables = t
      end
    end

    def self.notes_option(parser)
      parser.on('-n', '--notes', 'Convert content of HTML notes in the .md files in the given path recursively.') do |n|
        @options.notes = n
      end
    end

    def self.notes_html_option(parser)
      parser.on('-h', '--notes_html', 'Convert HTML notes WITHOUT "mardown=1" in the .md files in the given path recursively.') do |nh|
        @options.notes_html = nh
      end
    end
    
    def self.notes_with_md_option(parser)
      parser.on('-m', '--notes-with-md', 'Convert HTML notes WITH "mardown=1" in the .md files in the given path recursively.') do |nm|
        @options.notes_with_md = nm
      end
    end
  end
end
