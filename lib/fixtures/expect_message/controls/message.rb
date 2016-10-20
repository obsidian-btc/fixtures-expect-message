module Fixtures
  class ExpectMessage
    module Controls
      module Message
        def self.example
          SomeEventType.build
        end

        class SomeEventType
          include EventStore::Messaging::Message
        end
      end
    end
  end
end
