require 'test_helper'

module Votes
  class ToggleTest < ActiveSupport::TestCase
    setup do
      suffix = SecureRandom.hex(4)
      @user = User.create!(username: "toggle_user_#{suffix}", password: 'password123')
      @other_user = User.create!(username: "toggle_other_#{suffix}", password: 'password123')
      @link = @other_user.links.create!(title: "Toggle Link #{suffix}", url: 'https://example.com/toggle', description: 'Vote service coverage')
    end

    test 'creates a vote when none exists' do
      assert_difference('Vote.count', 1) do
        Votes::Toggle.call(user: @user, link: @link, value: Vote::UP)
      end

      vote = Vote.find_by!(user: @user, link: @link)

      assert vote.upvote?
      assert_equal 1, @link.reload.points
      assert_operator @link.hot_score, :>, 0.0
    end

    test 'removes the vote when the same direction is submitted again' do
      Vote.create!(user: @user, link: @link, value: Vote::UP)
      @link.refresh_ranking!

      assert_difference('Vote.count', -1) do
        Votes::Toggle.call(user: @user, link: @link, value: Vote::UP)
      end

      assert_equal 0, @link.reload.points
      assert_equal 0.0, @link.hot_score
    end

    test 'switches an existing vote direction' do
      Vote.create!(user: @user, link: @link, value: Vote::UP)

      assert_no_difference('Vote.count') do
        Votes::Toggle.call(user: @user, link: @link, value: Vote::DOWN)
      end

      assert Vote.find_by!(user: @user, link: @link).downvote?
      assert_equal(-1, @link.reload.points)
    end
  end
end
