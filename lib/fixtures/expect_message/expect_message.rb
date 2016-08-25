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

    def self.build(stream_name, session: nil)
      instance = new stream_name
      instance.configure_dependencies session: session
      instance
    end

    def configure_dependencies(session: nil)
      EventStore::Client::HTTP::Session.configure self, session: session
    end

    def call(event_type=nil, tries: nil, &block)
      tries ||= 1
      block ||= proc { true }

      if event_type
        inner_block = block

        block = proc { |event_data|
          event_data.type == event_type && inner_block.(event_data.data)
        }
      end

      loop do
        get_reader.each do |event_data|
          if block.(event_data)
            logger.info "Received expected message (Type: #{event_data.type})"
            return
          end

          error_message = "Next message written did not match expectation (ActualType: #{event_data.type.inspect}, ExpectedType: #{event_type.inspect})"
          logger.error error_message

          json_text = JSON.pretty_generate event_data.data.to_h
          logger.error json_text

          raise ExpectationNotMet, error_message
        end

        if tries == 1
          raise ExpectationNotMet, "Reply never written; is the component running?"
        else
          tries -= 1
        end
      end

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
