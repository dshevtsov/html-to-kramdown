require_relative '../lib/runner.rb'

runner = HtmlToKramdown::Runner.new(ARGV)
runner.run