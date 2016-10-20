module Fixtures
  class ExpectMessage
    module Controls
      module Write
        def self.call
          message = Message.example
          stream_name = StreamName.example

          writer = EventStore::Messaging::Writer.build
          writer.write message, stream_name

          stream_name
        end
      end
    end
  end
end
