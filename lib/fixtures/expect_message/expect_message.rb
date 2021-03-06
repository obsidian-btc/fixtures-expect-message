module Fixtures
  class ExpectMessage
    include Log::Dependency

    attr_accessor :position
    attr_reader :stream_name

    dependency :session, EventSource::EventStore::HTTP::Session

    def initialize(stream_name)
      @stream_name = stream_name
      @position = 0
    end

    def self.build(stream_name, session: nil)
      instance = new stream_name
      instance.configure_dependencies session: session
      instance
    end

    def self.call(stream_name, event_types=nil, retries: nil, session: nil, any_order: nil, &block)
      instance = build stream_name, session: session
      instance.(event_types, retries: retries, any_order: any_order, &block)
    end

    def configure_dependencies(session: nil)
      EventSource::EventStore::HTTP::Session.configure self, session: session
    end

    def call(event_types=nil, retries: nil, any_order: nil, &block)
      event_types ||= []
      event_types = event_types.is_a?(Array) ? event_types : [event_types]
      retries ||= 0
      block ||= proc { true }

      messages_count = event_types.count
      types = event_types.dup

      if messages_count > 0 && any_order
        inner_block = block

        block = proc { |event_data|
          types.include?(event_data.type) && inner_block.(event_data.data)
        }
      elsif messages_count > 0
        inner_block = block

        block = proc { |event_data|
          types[0] == event_data.type && inner_block.(event_data.data)
        }
      end

      messages_read = 0

      begin
        get_reader.() do |event_data|
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

        not_written_message = "MessagesWritten: #{event_types - types}, MessagesNotWritten: #{types}"

        raise MessageNotWritten, "Message never written; is the component running? #{not_written_message}"

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
      EventSource::EventStore::HTTP::Read.build(
        stream_name,
        position: position,
        session: session,
        cycle_timeout_milliseconds: nil,
        cycle_maximum_milliseconds: 1000
      )
    end

    ExpectationNotMet = Class.new StandardError
    MessageNotWritten = Class.new StandardError
  end
end
