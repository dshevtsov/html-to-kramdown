require 'minitest/autorun'
require_relative '../lib/crawler.rb'
include HtmlToKramdown

describe Crawler do
  before do
    @crawler = Crawler.new
  end

  describe 'when crawling the headings' do
    it 'must return the valid kramdown heading' do
      @crawler.headings_to_kramdown("<h2>This is a heading</h2>").must_equal "## This is a heading\n\n"
    end
  end

  describe 'when crawling the image' do
    it 'must return the valid kramdown image' do
      @crawler.images_to_kramdown('<img src="{{ site.baseurl }}/common/images/h5d-sectioning-flowchart.png">').must_equal '![]({{ site.baseurl }}/common/images/h5d-sectioning-flowchart.png)'
    end
  end

  describe 'when giving the external HTML link' do
    it 'must return the inline link in Kramdown' do
      @crawler.links_to_kramdown('<a href="http://www.nokogiri.org/tutorials/modifying_an_html_xml_document.html">Get this value</a>').must_equal "[Get this value](http://www.nokogiri.org/tutorials/modifying_an_html_xml_document.html)"
    end
  end

  describe 'when giving the internal HTML link' do
    it 'must return the inline link in Kramdown' do
      @crawler.links_to_kramdown('<a href="{{ page.baseurl }}/cloud/project/project-integrate-blackfire.html">Blackfire.io</a>').must_equal "[Blackfire.io]({{ page.baseurl }}/cloud/project/project-integrate-blackfire.html)"
    end
  end

  describe 'when giving the internal HTML link to section' do
    it 'must return the inline link in Kramdown' do
      @crawler.links_to_kramdown('<a href="#section">Blackfire.io</a>').must_equal "[Blackfire.io](#section)"
    end
  end

  describe 'when giving the internal HTML link to section' do
    it 'must return the inline link in Kramdown' do
      @crawler.tables_to_kramdown(<<-HTML
<table>
<thead>
    <tr>
        <th></th>
        <th></th>
        <th></th>
        <th></th>
        <th></th>
        <th></th>
    </tr>
</thead>
<tbody>
    <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
    </tr>
    <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
    </tr>
    <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
    </tr>
</tbody>
</table>
                  HTML
      ).must_equal(<<-KRMD
|  |  |  |  |  |  |
|----------
|  |  |  |  |  |  |
|  |  |  |  |  |  |
|  |  |  |  |  |  |


        KRMD
        )
    end
  end



end
