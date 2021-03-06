module Fixtures
  class ExpectMessage
    module Controls
      module Message
        def self.example
          SomeEventType.build
        end

        class SomeEvent
          include Messaging::Message
        end

        class SomeOtherEvent
          include Messaging::Message
        end

        module EventType
          def self.example
            SomeEvent.message_type
          end
        end

        module OtherEventType
          def self.example
            SomeOtherEvent.message_type
          end
        end
      end
    end
  end
end
