module HtmlToKramdown
  # Filters
  class Filter
    def headings
      %r{^\s*<h\d\s*.*>.+<\/h\d>}
    end

    def links
      %r{(<a href=.+</a>)}
    end

    def tables
      %r{(<table[^>]*>(?:.|\n)*?<\/table>)}
    end

    def images
      /(^<img.+>)/
    end
  end
end