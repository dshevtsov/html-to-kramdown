require 'minitest/autorun'
require_relative '../lib/converter.rb'
#require 'minitest/debugger'
include HtmlToKramdown

describe Converter do
  before do
    @converter = Converter.new
  end

  ESCAPED_CHAR_RE = /(\$\$|[\\*_`\[\]\{"'|])|^[ ]{0,3}(:)/
  
  describe 'when converting the heading with default options and no attributes' do
    it 'must return the valid kramdown heading with trailing new line' do
      @converter.to_kramdown('<h2>This is a heading</h2>').must_equal "## This is a heading\n"
    end
  end

  describe 'when converting the heading with default options and id attribute' do
    it 'must return the valid kramdown heading with id in kramdown with trailing new line' do
      @converter.to_kramdown("<h2 id='heading'>This is a heading</h2>").must_equal "## This is a heading   {#heading}\n"
    end
  end

  describe 'when converting the heading with default options and id attribute' do
    it 'must return the valid kramdown heading with id in kramdown with trailing new line' do
      @converter.to_kramdown("<h2 id='heading'>This is a heading</h2>").must_equal "## This is a heading   {#heading}\n"
    end
  end

  describe 'when converting the link with Liquid variables' do
    it 'must return the valid inline kramdown link' do
      @converter.to_kramdown('<a href="{{ page.baseurl }}/cloud/project/project-conf-files_services-elastic.html#cloud-es-config-mg">Get this value</a>').must_equal "[Get this value]({{ page.baseurl }}/cloud/project/project-conf-files_services-elastic.html#cloud-es-config-mg)\n"
    end
  end

  describe 'when converting the external link' do
    it 'must return the valid inline kramdown link with trailing new line' do
      @converter.to_kramdown('<a href="http://www.nokogiri.org/tutorials/modifying_an_html_xml_document.html">Get this value</a>').must_equal "[Get this value](http://www.nokogiri.org/tutorials/modifying_an_html_xml_document.html)\n"
    end
  end

  describe 'when converting the image with default options and no text and attributes' do
    it 'must return the image in Kramdown with trailing new line' do
      @converter.to_kramdown('<img src="{{ site.baseurl }}/common/images/h5d-sectioning-flowchart.png">').must_equal "![]({{ site.baseurl }}/common/images/h5d-sectioning-flowchart.png)\n"
    end
  end

  describe 'when converting the text with {}' do
    it 'must return {} without escapting' do
      @converter.to_kramdown('{}').must_equal "{}"
    end
  end

  describe 'when giving the simple HTML table' do
    it 'must return the table in Kramdown with trailing new line' do
      @converter.to_kramdown(<<-HTML
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
