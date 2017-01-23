module Fixtures
  class ExpectMessage
    module Controls
      module Write
        def self.call(event_types=nil)
          event_types ||= Message::EventType.example
          event_types = event_types.is_a?(Array) ? event_types : [event_types]

          messages = []
          event_types.each do |event_type|
            messages << Message.const_get(event_type).build
          end

          stream_name = StreamName.example

          write = Messaging::EventStore::Write.build
          write.(messages, stream_name)

          stream_name
        end
      end
    end
  end
end
