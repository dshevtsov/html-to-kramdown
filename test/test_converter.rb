require 'minitest/autorun'
require_relative '../lib/converter.rb'
# require 'minitest/debugger'
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
      @converter.to_kramdown('<a href="{{ page.baseurl }}/cloud/project/project-conf-files_services-elastic.html#cloud-es-config-mg">Get this value</a>').must_equal '[Get this value]({{ page.baseurl }}/cloud/project/project-conf-files_services-elastic.html#cloud-es-config-mg)'
    end
  end

  describe 'when converting the link with braces in text' do
    it 'must return the valid inline kramdown link' do
      @converter.to_kramdown('<a href="{{ page.baseurl }}/cloud/project/project-conf-files_services-elastic.html#cloud-es-config-mg">Get this {value}</a>').must_equal '[Get this {value}]({{ page.baseurl }}/cloud/project/project-conf-files_services-elastic.html#cloud-es-config-mg)'
    end
  end

  describe 'when converting the external link' do
    it 'must return the valid inline kramdown link with trailing new line' do
      @converter.to_kramdown('<a href="http://www.nokogiri.org/tutorials/modifying_an_html_xml_document.html">Get this value</a>').must_equal '[Get this value](http://www.nokogiri.org/tutorials/modifying_an_html_xml_document.html)'
    end
  end

  describe 'when converting the image with default options and no text and attributes' do
    it 'must return the image in Kramdown with trailing new line' do
      @converter.to_kramdown('<img src="{{ site.baseurl }}/common/images/h5d-sectioning-flowchart.png">').must_equal '![]({{ site.baseurl }}/common/images/h5d-sectioning-flowchart.png)'
    end
  end

  describe 'when converting an HTML note wrapped in div'  do
    it 'must return its content converted in Kramdown and markdown parsing enabled' do
      @converter.to_kramdown(<<-HTML
  <div class="bs-callout bs-callout-warning">
    <p>Don’t configure the module in your local before building and deploying. You’ll configure the module in those environments.</p>

    <p>We recommend using the <code>bin/magento magento-cloud:scd-dump</code> command for Configuration Management
  (<a href="{{ site.baseurl }}/guides/v2.1/cloud/live/sens-data-over.html#cloud-config-specific-recomm">2.1.X</a>,
    <a href="{{ site.baseurl }}/guides/v2.2/cloud/live/sens-data-over.html#cloud-config-specific-recomm">2.2.X</a>).
    If you use the <code>app:config:dump</code> command, all configuration options for Fastly will be locked from editing in Staging and Production.</p>
  </div>
      HTML
                            ).must_equal <<-KRAMDOWN
<div class="bs-callout bs-callout-warning" markdown="1">
Don’t configure the module in your local before building and deploying. You’ll configure the module in those environments.
We recommend using the `bin/magento magento-cloud:scd-dump` command for Configuration Management ([2.1.X]({{ site.baseurl }}/guides/v2.1/cloud/live/sens-data-over.html#cloud-config-specific-recomm), [2.2.X]({{ site.baseurl }}/guides/v2.2/cloud/live/sens-data-over.html#cloud-config-specific-recomm)). If you use the `app:config:dump` command, all configuration options for Fastly will be locked from editing in Staging and Production.
</div>
      KRAMDOWN
    end
  end

  describe 'when converting a note wrapped in div with mixed HTML and with markdown="1"' do
    it 'must return the note converted in Kramdown' do
      @converter.to_kramdown(<<-HTML
<div class="bs-callout bs-callout-warning" markdown="1">
Don’t configure the module in your local before building and deploying. You’ll configure the module in those environments.

We recommend using the `bin/magento magento-cloud:scd-dump` command for Configuration Management
(<a href="{{ site.baseurl }}/guides/v2.1/cloud/live/sens-data-over.html#cloud-config-specific-recomm">2.1.X</a>,
<a href="{{ site.baseurl }}/guides/v2.2/cloud/live/sens-data-over.html#cloud-config-specific-recomm">2.2.X</a>).
<p>If you use the <code>app:config:dump</code> command, all configuration options for Fastly will be locked from editing in Staging and Production.</p>
</div>
      HTML
                            ).must_equal <<-KRAMDOWN
<div class="bs-callout bs-callout-warning" markdown="1">
Don’t configure the module in your local before building and deploying. You’ll configure the module in those environments. We recommend using the `bin/magento magento-cloud:scd-dump` command for Configuration Management ([2.1.X]({{ site.baseurl }}/guides/v2.1/cloud/live/sens-data-over.html#cloud-config-specific-recomm), [2.2.X]({{ site.baseurl }}/guides/v2.2/cloud/live/sens-data-over.html#cloud-config-specific-recomm)).
If you use the `app:config:dump` command, all configuration options for Fastly will be locked from editing in Staging and Production.
</div>
      KRAMDOWN
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

  # TODO: TEST
  # <div class="bs-callout bs-callout-info" id="info" markdown="1">
  # The extension name is in the format `<VendorName>_<ComponentName>`; it's not the same format as the Composer name. Use this format to enable the extension.
  # </div>
end
