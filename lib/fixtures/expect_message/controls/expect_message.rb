module Fixtures
  class ExpectMessage
    module Controls
      module ExpectMessage
        def self.example(stream_name=nil)
          stream_name ||= StreamName.example

          instance = Fixtures::ExpectMessage.build stream_name

          instance
        end
      end
    end
  end
end
