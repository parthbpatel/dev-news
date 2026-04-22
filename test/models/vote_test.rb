require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  setup do
    suffix = SecureRandom.hex(4)
    @user = User.create!(username: "voter_#{suffix}", password: 'password123')
    @link = @user.links.create!(title: "Vote Test Link #{suffix}", url: 'https://example.com', description: 'Vote model coverage')
  end

  test 'requires a supported direction value' do
    vote = Vote.new(user: @user, link: @link, value: 0)

    assert_not vote.valid?
    assert_includes vote.errors[:value], 'is not included in the list'
  end

  test 'reports its direction helpers' do
    upvote = Vote.new(user: @user, link: @link, value: Vote::UP)
    downvote = Vote.new(user: @user, link: @link, value: Vote::DOWN)

    assert upvote.upvote?
    assert_not upvote.downvote?
    assert downvote.downvote?
    assert_not downvote.upvote?
  end
end
