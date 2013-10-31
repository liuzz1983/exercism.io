require './test/integration_helper'

class MuteTest < Minitest::Test

  def teardown
    super
    @alice = nil
    @bob = nil
    @submission = nil
  end

  def a_week
    60 * 60 * 24 * 7
  end

  def alice
    @alice ||= User.create(username: 'alice', mastery: ['ruby'])
  end

  def bob
    @bob ||= User.create(username: 'bob')
  end

  def submission
    @submission ||= Submission.create(user: bob, language: 'ruby', slug: 'bob', created_at: Time.now - (a_week*2))
  end

  def test_mute_pending_submission
    refute submission.muted_by?(alice), "Unexpectedly muted"
    Mute.new(submission, alice).save
    submission.reload
    assert submission.muted_by?(alice), "Should be muted"
  end

  def test_do_not_mute_superseded_submission
    submission.state = 'superseded'
    Mute.new(submission, alice).save
    submission.reload
    refute submission.muted_by?(alice), "Unexpectedly muted"
  end
end
