require 'minitest/autorun'
require_relative '../lib/converter.rb'
include HtmlToKramdown

describe Converter do
    before do
        @converter = Converter.new
    end

    describe 'when converting the heading with default options and no attributes' do
        it 'must return the valid kramdown heading' do
            @converter.to_kramdown("<h2>This is a heading</h2>").must_equal "## This is a heading\n\n"
        end
    end

    describe 'when converting the heading with default options and id attribute' do
        it 'must return the valid kramdown heading with id in kramdown' do
            @converter.to_kramdown("<h2 id='heading'>This is a heading</h2>").must_equal "## This is a heading   {#heading}\n\n"
        end
    end
end

    