module Fixtures
  class ExpectMessage
    module Controls
      module StreamName
        def self.example
          stream_id = Identifier::UUID::Controls::Random.example
          category = 'someCategory'

          Messaging::StreamName.stream_name stream_id, category
        end
      end
    end
  end
end
