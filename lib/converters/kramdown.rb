require 'kramdown'

module Kramdown
  module Converter
    # Converts an element tree to the kramdown format.
    class Kramdown
      def convert_a(el, opts)
        if el.attr['href'].empty?
          "[#{inner(el, opts)}]()"
        else
          title = parse_title(el.attr['title'])
          "[#{inner(el, opts)}](#{el.attr['href']}#{title})"
        end
      end
    end
  end
end
