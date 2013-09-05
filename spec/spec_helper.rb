require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

$:.unshift File.expand_path('../../', __FILE__)

require 'rspec'
require 'rr'
require 'vidibus-sysinfo'

RSpec.configure do |config|
  config.mock_with :rr
end
