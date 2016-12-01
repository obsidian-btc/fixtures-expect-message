require_relative '../automated_init'

context "Multiple events, events must be written in specified order" do
  context "Event types specified match order of event types written" do
    event_types = Controls::EventTypes.example

    stream_name = Controls::Write.(event_types)
    expect_message = Controls::ExpectMessage.example stream_name

    test "Returns true" do
      assert expect_message.(event_types)
    end
  end

  context "Event types specified match event types written in the wrong order" do
    event_types = Controls::EventTypes.example

    stream_name = Controls::Write.(event_types)
    expect_message = Controls::ExpectMessage.example stream_name

    test "Error is raised" do
      reversed_event_types = event_types.reverse

      assert proc { expect_message.(reversed_event_types) } do
        raises_error? Fixtures::ExpectMessage::ExpectationNotMet
      end
    end
  end

  context "Event types specified do not match event types written" do
    event_types = Controls::EventTypes.example

    stream_name = Controls::Write.(event_types)
    expect_message = Controls::ExpectMessage.example stream_name

    test "Error is raised" do
      assert proc { expect_message.('WrongEventType') } do
        raises_error? Fixtures::ExpectMessage::ExpectationNotMet
      end
    end
  end
end
