module Fixtures
  class ExpectMessage
    module Controls
      module EventTypes
        def self.example
          [Message::EventType.example, Message::OtherEventType.example]
        end
      end
    end
  end
end
