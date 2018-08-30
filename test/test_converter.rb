require 'minitest/autorun'
require_relative '../lib/converter.rb'
include HtmlToKramdown

describe Converter do
  before do
    @converter = Converter.new
  end

  describe 'when converting the heading with default options and no attributes' do
    it 'must return the valid kramdown heading' do
      @converter.to_kramdown('<h2>This is a heading</h2>').must_equal "## This is a heading\n\n"
    end
  end

  describe 'when converting the heading with default options and id attribute' do
    it 'must return the valid kramdown heading with id in kramdown' do
      @converter.to_kramdown("<h2 id='heading'>This is a heading</h2>").must_equal "## This is a heading   {#heading}\n\n"
    end
  end

  describe 'when converting the heading with default options and id attribute' do
    it 'must return the valid kramdown heading with id in kramdown' do
      @converter.to_kramdown("<h2 id='heading'>This is a heading</h2>").must_equal "## This is a heading   {#heading}\n\n"
    end
  end

  describe 'when converting the link with Liquid variables' do
    it 'must return the valid kramdown link' do
      @converter.to_kramdown('<a href="{{ page.baseurl }}/cloud/project/project-conf-files_services-elastic.html#cloud-es-config-mg">Get this value</a>').must_equal "[Get this value]({{ page.baseurl }}/cloud/project/project-conf-files_services-elastic.html#cloud-es-config-mg)\n\n"
    end
  end

  describe 'when converting the external link' do
    it 'must return the valid kramdown link' do
      @converter.to_kramdown('<a href="http://www.nokogiri.org/tutorials/modifying_an_html_xml_document.html">Get this value</a>').must_equal "[Get this value](http://www.nokogiri.org/tutorials/modifying_an_html_xml_document.html)\n\n"
    end
  end

  describe 'when giving the simple HTML table' do
    it 'must return the table in Kramdown' do
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
