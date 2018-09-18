require 'kramdown'
# Disabling some functionality commenting it out
module Kramdown
  module Converter
    # Converts an element tree to the kramdown format.
    class Kramdown
      #ESCAPED_CHAR_RE = /(\$\$)|^[ ]{0,3}(:)/

      # Remove the links definitions conversion
      def convert_a(el, opts)
        if el.attr['href'].empty?
          "[#{inner(el, opts)}]()"
        # elsif el.attr['href'] =~ /^(?:http|ftp)/ || el.attr['href'].count("()") > 0
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

      # Disabling addition of an extra new line and excaping
      def convert(el, opts = { indent: 0 })
        res = send("convert_#{el.type}", el, opts)
        if !%i[html_element li dt dd td].include?(el.type) && (ial = ial_for_element(el))
          res << ial
          res << "\n\n" if Element.category(el) == :block
        elsif %i[ul dl ol codeblock].include?(el.type) && opts[:next] &&
              ([el.type, :codeblock].include?(opts[:next].type) ||
              (opts[:next].type == :blank && opts[:nnext] && [el.type, :codeblock].include?(opts[:nnext].type)))
          res << "^\n\n"
           elsif Element.category(el) == :block &&
              ![:li, :dd, :dt, :td, :th, :tr, :thead, :tbody, :tfoot, :blank].include?(el.type) &&
              (el.type != :html_element || @stack.last.type != :html_element) &&
              (el.type != :p || !el.options[:transparent])
            res << "\n"
        end
        res
      end

      # Disable escaping for special characters in text
      def convert_text(el, opts)
        if opts[:raw_text]
          el.value
        else
          el.value.gsub(/\A\n/) do
            opts[:prev] && opts[:prev].type == :br ? '' : "\n"
          end#.gsub(/\s+/, ' ').gsub(ESCAPED_CHAR_RE) { "\\#{$1 || $2}" }
        end
      end

      # Disable escaping for special characters in alt text of images
      def convert_img(el, opts)
        alt_text = el.attr['alt'].to_s#.gsub(ESCAPED_CHAR_RE) { $1 ? "\\#{$1}" : $2 }
        src = el.attr['src'].to_s
        if src.empty?
          "![#{alt_text}]()"
        else
          title = parse_title(el.attr['title'])
          link = if src.count("()") > 0
                   "<#{src}>"
                 else
                   src
                 end
          "![#{alt_text}](#{link}#{title})"
        end
      end
    end
  end
end
