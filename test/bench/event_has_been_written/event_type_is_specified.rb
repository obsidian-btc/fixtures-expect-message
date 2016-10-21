require_relative '../bench_init'

context "Event has been written, event type is specified" do
  context "Event type specified matches event type written" do
    event_type = Fixtures::ExpectMessage::Controls::Message::EventType.example

    context do
      stream_name = Fixtures::ExpectMessage::Controls::Write.()
      expect_message = Fixtures::ExpectMessage::Controls::ExpectMessage.example stream_name

      test "Returns true" do
        assert expect_message.(event_type)
      end
    end

    context "Block is provided and predicate returns true" do
      stream_name = Fixtures::ExpectMessage::Controls::Write.()
      expect_message = Fixtures::ExpectMessage::Controls::ExpectMessage.example stream_name

      test "Returns true" do
        assert expect_message.(event_type) {|_| true}
      end
    end

    context "Block is provided and predicate returns false" do
      stream_name = Fixtures::ExpectMessage::Controls::Write.()
      expect_message = Fixtures::ExpectMessage::Controls::ExpectMessage.example stream_name

      test "Error is raised" do
        assert proc { expect_message.(event_type) {|_| false} } do
          raises_error? Fixtures::ExpectMessage::ExpectationNotMet
        end
      end
    end
  end

  context "Event type specified does not match event type written" do
    stream_name = Fixtures::ExpectMessage::Controls::Write.()
    expect_message = Fixtures::ExpectMessage::Controls::ExpectMessage.example stream_name

    test "Error is raised" do
      assert proc { expect_message.('SomeOtherEvent') } do
        raises_error? Fixtures::ExpectMessage::ExpectationNotMet
      end
    end
  end
end
