require_relative '../automated_init'

context "Event has been written, event type is not specified" do
  stream_name = Controls::Write.()

  expect_message = Controls::ExpectMessage.example stream_name

  test "No error is raised" do
    assert expect_message.()
  end
end
