require 'kramdown'
# Override the 'converter/kramdown' to disable link definitions
module Kramdown
  module Converter
    # Converts an element tree to the kramdown format.
    class Kramdown

      ESCAPED_CHAR_RE = /(\$\$|])|^[ ]{0,3}(:)/

      # Remove the links definitions conversion
      def convert_a(el, opts)
        if el.attr['href'].empty?
          "[#{inner(el, opts)}]()"
        #elsif el.attr['href'] =~ /^(?:http|ftp)/ || el.attr['href'].count("()") > 0
        #  index = if link_el = @linkrefs.find {|c| c.attr['href'] == el.attr['href']}
        #           @linkrefs.index(link_el) + 1
        #          else
        #            @linkrefs << el
        #            @linkrefs.size
        #          end
        #  "[#{inner(el, opts)}][#{index}]"
        else
          title = parse_title(el.attr['title'])
          "[#{inner(el, opts)}](#{el.attr['href']}#{title})"
        end
      end

      # Disabling addition of an extra new line
      def convert(el, opts = {:indent => 0})
        res = send("convert_#{el.type}", el, opts)
        if ![:html_element, :li, :dt, :dd, :td].include?(el.type) && (ial = ial_for_element(el))
          res << ial
          res << "\n\n" if Element.category(el) == :block
        elsif [:ul, :dl, :ol, :codeblock].include?(el.type) && opts[:next] &&
            ([el.type, :codeblock].include?(opts[:next].type) ||
            (opts[:next].type == :blank && opts[:nnext] && [el.type, :codeblock].include?(opts[:nnext].type)))
          res << "^\n\n"
        #elsif Element.category(el) == :block &&
        #    ![:li, :dd, :dt, :td, :th, :tr, :thead, :tbody, :tfoot, :blank].include?(el.type) &&
        #    (el.type != :html_element || @stack.last.type != :html_element) &&
        #    (el.type != :p || !el.options[:transparent])
        #  res << "\n"
        end
        res
      end
    end
  end
end
