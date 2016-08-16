require 'event_store/client/http'

module Fixtures
  class ExpectReply
    include Telemetry::Logger::Dependency

    attr_accessor :position
    attr_reader :reply_stream_name

    dependency :session, EventStore::Client::HTTP::Session

    def initialize(reply_stream_name)
      @reply_stream_name = reply_stream_name
      @position = 0
    end

    def self.build(session: nil)
      stream_id = Identifier::UUID::Random.get

      reply_stream_name = "fixturesExpectReply-#{stream_id}"

      instance = new reply_stream_name
      EventStore::Client::HTTP::Session.configure instance, session: session
      instance
    end

    def call(event_type=nil, block)
      if event_type
        block = proc { |event_data| event_data.type == event_type }
      end

      get_reader.each do |event_data|
        if block.(event_data)
          logger.info "Received expected reply (Type: #{event_data.type})"
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
        reply_stream_name,
        starting_position: position,
        session: session
      )
    end

    ExpectationNotMet = Class.new StandardError
  end
end
