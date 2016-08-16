module Fixtures
  class ExpectMessage
    include Telemetry::Logger::Dependency

    attr_accessor :position
    attr_reader :stream_name

    dependency :session, EventStore::Client::HTTP::Session

    def initialize(stream_name)
      @stream_name = stream_name
      @position = 0
    end

    def configure_dependencies
      EventStore::Client::HTTP::Session.configure self, session: session
    end

    def call(event_type=nil, &block)
      if event_type
        block = proc { |event_data| event_data.type == event_type }
      end

      get_reader.each do |event_data|
        if block.(event_data)
          logger.info "Received expected message (Type: #{event_data.type})"
          return
        end

        json_text = JSON.pretty_generate event_data.to_h
        logger.focus json_text

        raise ExpectationNotMet, "Expectation not met"
      end

      raise ExpectationNotMet, "Reply never written; is the component running?"

    ensure
      self.position += 1
    end

    def get_reader
      EventStore::Client::HTTP::Subscription.build(
        stream_name,
        starting_position: position,
        session: session
      )
    end

    ExpectationNotMet = Class.new StandardError
  end
end
