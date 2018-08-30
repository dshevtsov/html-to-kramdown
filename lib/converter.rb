require_relative 'converters/kramdown.rb'
require 'pandoc-ruby'
module HtmlToKramdown
  # Converts input HTML to kramdown
  class Converter
    def default_options
      { html_to_native: true, line_width: 1000 }
    end

    def to_kramdown(string, options = {})
      document = Kramdown::Document.new(string, default_options.merge(options))
      document.to_kramdown
    end
  end
end