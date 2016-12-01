ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_LEVEL'] ||= '_min'

ENV['ENTITY_CACHE_SCOPE'] ||= 'exclusive'

require_relative '../init.rb'
require 'fixtures/expect_message/controls'

require 'test_bench/activate'

require 'pp'

Controls = Fixtures::ExpectMessage::Controls
