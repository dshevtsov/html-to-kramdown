require_relative 'filter'
require_relative 'converter'

module HtmlToKramdown
  # Crawl the content for specific HTML elements,
  # convert them to Kramdown, and return the updated content
  class Crawler
    def links_to_kramdown(content)
      content.gsub(links, &replace)
    end

    def headings_to_kramdown(content)
      content.gsub(headings, &replace)
    end

    def images_to_kramdown(content)
      content.gsub(images, &replace)
    end

    def tables_to_kramdown(content)
      content.gsub(tables, &replace)
    end

    def substitute
      convert_to_kramdown(matcher)
    end

    def replace
      ->(s) { convert_to_kramdown(s) }
    end

    def convert_to_kramdown(string, options = {})
      converter.to_kramdown(string, options).delete!("\n\n")
    end

    def matcher
      Regexp.last_match(1).to_s
    end

    def converter
      Converter.new
    end

    def filter
      Filter.new
    end

    def headings
      filter.headings
    end

    def images
      filter.images
    end

    def links
      filter.links
    end

    def tables
      filter.tables
    end
  end
end
