require_relative '../bench_init'

context "Event has been written, event type is not specified" do
  stream_name = Fixtures::ExpectMessage::Controls::Write.()

  expect_message = Fixtures::ExpectMessage::Controls::ExpectMessage.example stream_name

  test "No error is raised" do
    refute proc { expect_message.() } do
      raises_error? Fixtures::ExpectMessage::MessageNotWritten
    end
  end
end
