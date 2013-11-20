require 'test_helper'

class DoneMailerTest < ActionMailer::TestCase
  test "done" do
    mail = DoneMailer.done
    assert_equal "Done", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
