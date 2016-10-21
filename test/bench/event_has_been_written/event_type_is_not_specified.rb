require_relative '../bench_init'

context "Event has been written, event type is not specified" do
  stream_name = Fixtures::ExpectMessage::Controls::Write.()

  expect_message = Fixtures::ExpectMessage::Controls::ExpectMessage.example stream_name

  test "No error is raised" do
    assert expect_message.()
  end
end
