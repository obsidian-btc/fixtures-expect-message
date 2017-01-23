module Fixtures
  class ExpectMessage
    module Controls
      module ExpectMessage
        def self.example(stream_name=nil, terminal_reader: nil)
          stream_name ||= StreamName.example

          instance = Fixtures::ExpectMessage.build stream_name

          if terminal_reader
            def instance.get_reader
              EventSource::EventStore::HTTP::Read.build(
                stream_name,
                position: position,
                session: session
              )
            end
          end

          instance
        end
      end
    end
  end
end
