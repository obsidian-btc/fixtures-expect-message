module Fixtures
  class ExpectMessage
    class Reply < ExpectMessage
      def self.build(session: nil)
        stream_id = Identifier::UUID::Random.get

        stream_name = "fixturesExpectMessage-#{stream_id}"

        instance = new stream_name
        instance.configure_dependencies
        instance
      end
    end
  end
end
