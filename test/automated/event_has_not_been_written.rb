require_relative './automated_init'

context "Event has not been written" do
  expect_message = Controls::ExpectMessage.example terminal_reader: true

  test "Error is raised" do
    assert proc { expect_message.() } do
      raises_error? Fixtures::ExpectMessage::MessageNotWritten
    end
  end

  context "Event type is specified" do
    test "Error is raised" do
      assert proc { expect_message.() } do
        raises_error? Fixtures::ExpectMessage::MessageNotWritten
      end
    end
  end
end
