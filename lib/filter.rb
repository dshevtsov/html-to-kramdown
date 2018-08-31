module HtmlToKramdown
  # Filters
  class Filter
    def headings
      %r{^\s*<h\d\s*.*>.+<\/h\d>}
    end

    def links
      %r{<a href=.+</a>}
    end

    def tables
      %r{<table[^>]*>(?:.|\n)*?<\/table>}
   end

    def images
      /(^<img.+>)/
    end

    def notes
      %r{<div class="bs-callout bs-callout.+>(?:.|\n)*?<\/div>}
    end

    # TODO
    def lists; end
  end
end
