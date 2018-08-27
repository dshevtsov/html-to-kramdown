require 'minitest/autorun'
require_relative '../lib/crawler.rb'
include HtmlToKramdown

describe Crawler do
  before do
    @crawler = Crawler.new
  end

  describe 'when crawling the headings' do
    it 'must return the valid kramdown heading' do
      @crawler.headings_to_kramdown("<h2>This is a heading</h2>\n\nThis is a section.").must_equal "## This is a heading\n\nThis is a section."
    end
  end

  describe 'when crawling the image' do
    it 'must return the valid kramdown image' do
      @crawler.images_to_kramdown('<img src="{{ site.baseurl }}/common/images/h5d-sectioning-flowchart.png">').must_equal '![]({{ site.baseurl }}/common/images/h5d-sectioning-flowchart.png)'
    end
  end

  describe 'when giving HTML' do
    it 'must return the same content in Kramdown' do
      @crawler.convert_to_kramdown('<code>Hello</code>').must_equal '`Hello`'
    end
  end
end
