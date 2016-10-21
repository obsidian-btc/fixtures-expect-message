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

    def self.call(stream_name, event_type=nil, retries: nil, session: nil, &block)
      instance = build stream_name, session: session
      instance.(event_type, retries: retries, &block)
    end

    def configure_dependencies(session: nil)
      EventStore::Client::HTTP::Session.configure self, session: session
    end

    def call(event_types=nil, retries: nil, any_order: nil, &block)
      event_types ||= []
      event_types = event_types.is_a?(Array) ? event_types : [event_types]
      retries ||= 0
      any_order ||= false
      block ||= proc { true }

      messages_count = event_types.count

      if messages_count > 0 && any_order
        inner_block = block

        block = proc { |event_data|
          event_types.include?(event_data.type) && inner_block.(event_data.data)
        }
      elsif messages_count > 0
        inner_block = block

        block = proc { |event_data|
          event_types[0] == event_data.type && inner_block.(event_data.data)
        }
      end

      messages_read = 0
      types = event_types

      begin
        get_reader.each do |event_data|
          messages_read += 1

          if block.(event_data)
            logger.info "Received expected message (Type: #{event_data.type})"
            types.delete_at(types.index(event_data.type) || messages_count)
            if messages_read < messages_count; next; else; return true; end
          end

          if any_order
            expected_type_message = "ExpectedTypes: #{types.inspect}"
          else
            expected_type_message = "ExpectedType: #{types[0].inspect}"
          end

          error_message = "Next message written did not match expectation (ActualType: #{event_data.type.inspect}, #{expected_type_message})"
          logger.error error_message

          json_text = JSON.pretty_generate event_data.data.to_h
          logger.error json_text

          raise ExpectationNotMet, error_message
        end

        if any_order
          not_written_message = ""
        else
          not_written_message = ""
        end

        raise MessageNotWritten, "Message never written; is the component running?"

      rescue MessageNotWritten
        if retries > 0
          retries -= 1
          retry
        else
          raise
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
    MessageNotWritten = Class.new StandardError
  end
end
