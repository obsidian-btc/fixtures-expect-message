require_relative '../automated_init'

context "Multiple events, events can be written in any order" do
  context "Event types specified match event types written" do
    context do
      event_types = Controls::EventTypes.example

      stream_name = Controls::Write.(event_types)
      expect_message = Controls::ExpectMessage.example stream_name

      test "Returns true" do
        assert expect_message.(event_types, any_order: true)
      end
    end

    context "Block is provided and predicate returns true" do
      event_types = Controls::EventTypes.example

      stream_name = Controls::Write.(event_types)
      expect_message = Controls::ExpectMessage.example stream_name

      test "Returns true" do
        assert expect_message.(event_types, any_order: true) {|_| true}
      end
    end

    context "Block is provided and predicate returns false" do
      event_types = Controls::EventTypes.example

      stream_name = Controls::Write.(event_types)
      expect_message = Controls::ExpectMessage.example stream_name

    test "Error is raised" do
        assert proc { expect_message.(event_types, any_order: true) {|_| false} } do
          raises_error? Fixtures::ExpectMessage::ExpectationNotMet
        end
      end
    end
  end

  context "Event types specified do not match event types written" do
    event_types = Controls::EventTypes.example

    stream_name = Controls::Write.(event_types)
    expect_message = Controls::ExpectMessage.example stream_name

    test "Error is raised" do
      assert proc { expect_message.('WrongEventType', any_order: true) } do
        raises_error? Fixtures::ExpectMessage::ExpectationNotMet
      end
    end
  end
end
