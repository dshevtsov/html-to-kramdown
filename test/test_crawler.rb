require 'minitest/autorun'
require_relative '../lib/crawler.rb'
include HtmlToKramdown

describe Crawler do
  before do
    @crawler = Crawler.new
  end

  describe 'when crawling the headings' do
    it 'must return the valid kramdown heading' do
      @crawler.headings_to_kramdown('<h2>This is a heading</h2>').must_equal "## This is a heading"
    end
  end

  describe 'when crawling the image' do
    it 'must return the valid kramdown image' do
      @crawler.images_to_kramdown('<img src="{{ site.baseurl }}/common/images/h5d-sectioning-flowchart.png">').must_equal "![]({{ site.baseurl }}/common/images/h5d-sectioning-flowchart.png)"
    end
  end

  describe 'when giving the external HTML link' do
    it 'must return the inline link in Kramdown' do
      @crawler.links_to_kramdown('<a href="http://www.nokogiri.org/tutorials/modifying_an_html_xml_document.html">Get this value</a>').must_equal '[Get this value](http://www.nokogiri.org/tutorials/modifying_an_html_xml_document.html)'
    end
  end

  describe 'when giving the internal HTML link' do
    it 'must return the inline link in Kramdown' do
      @crawler.links_to_kramdown('<a href="{{ page.baseurl }}/cloud/project/project-integrate-blackfire.html">Blackfire {{io}}</a>').must_equal '[Blackfire {{io}}]({{ page.baseurl }}/cloud/project/project-integrate-blackfire.html)'
    end
  end

  describe 'when giving the internal HTML link to section' do
    it 'must return the inline link in Kramdown' do
      @crawler.links_to_kramdown('<a href="#section">Blackfire.io</a>').must_equal '[Blackfire.io](#section)'
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

  describe 'when converting an HTML note wrapped in div'  do
    it 'must return its content converted in Kramdown and markdown parsing enabled' do
      @crawler.notes_to_kramdown(<<-HTML
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
      @crawler.notes_to_kramdown(<<-HTML
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

  describe 'when converting a note wrapped in div with markdown="1" but with no HTML ' do
    it 'must remain it as is' do
      @crawler.notes_to_kramdown(<<-HTML
<div class="bs-callout bs-callout-info" id="info" markdown="1">
We'll periodically add more cache alternatives so watch this space.
</div>
      HTML
                                ).must_equal <<-KRAMDOWN
<div class="bs-callout bs-callout-info" id="info" markdown="1">
We'll periodically add more cache alternatives so watch this space.
</div>
      KRAMDOWN
    end
  end

  ##TOtest
#<div class="bs-callout bs-callout-info" markdown="1">

#* Each part has a header and body with `Content-Disposition` header always set to `form-data`.
#* The `name` value must be set to `file[]` for all parts.
#* The original filename must be supplied in the `filename` parameter.
#* The `Content-Type` header must be set to the appropriate mime-type for the file.
#* The body of each part is the full contents of the raw file.
#</div>

##TOtest
#<div class="bs-callout bs-callout-info" id="info" markdown="1">
#The default configuration is set in [`<magento2>/dev/tests/functional/etc/config.xml.dist`]({{ site.mage2000url }}dev/tests/functional/etc/config.xml.dist). It should be copied as `config.xml` for further changes.
#</div>

##TOtest
#<div class="bs-callout bs-callout-info">
#<a href="{{ page.baseurl }}/cloud/bk-cloud.html">{{site.data.var.ece}}</a> supports production mode only.
#</div>

end
