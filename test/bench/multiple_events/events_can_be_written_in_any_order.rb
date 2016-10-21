require_relative '../bench_init'

context "Multiple events, events can be written in any order" do
  context "Event types specified match event types written" do
    event_types = Fixtures::ExpectMessage::Controls::EventTypes.example

    stream_name = Fixtures::ExpectMessage::Controls::Write.(event_types)
    expect_message = Fixtures::ExpectMessage::Controls::ExpectMessage.example stream_name

    test "Returns true" do
      assert expect_message.(event_types, any_order: true)
    end
  end
end
__END__

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
end
