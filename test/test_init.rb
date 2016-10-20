ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_COLOR'] ||= 'on'

if ENV['LOG_LEVEL']
  ENV['LOGGER'] ||= 'on'
else
  ENV['LOG_LEVEL'] ||= 'trace'
end

ENV['LOGGER'] ||= 'off'
ENV['ENTITY_CACHE_SCOPE'] ||= 'exclusive'

require 'pp'

require_relative '../init.rb'
require 'fixtures/expect_message/controls'

require 'test_bench/activate'

Telemetry::Logger::AdHoc.activate
