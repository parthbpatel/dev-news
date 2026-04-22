require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  setup do
    suffix = SecureRandom.hex(4)
    @user = User.create!(username: "link_owner_#{suffix}", password: 'password123')
    @link = @user.links.create!(title: "Link Test #{suffix}", url: 'https://example.com', description: 'Link model coverage')
  end

  test 'refresh_ranking! stores the current vote total' do
    Vote.create!(user: @user, link: @link, value: Vote::UP)
    other_user = User.create!(username: "other_#{SecureRandom.hex(4)}", password: 'password123')
    Vote.create!(user: other_user, link: @link, value: Vote::DOWN)

    @link.refresh_ranking!

    assert_equal 0, @link.reload.points
    assert_equal 0.0, @link.hot_score
  end

  test 'vote_total sums the normalized vote values' do
    Vote.create!(user: @user, link: @link, value: Vote::UP)
    other_user = User.create!(username: "sum_#{SecureRandom.hex(4)}", password: 'password123')
    Vote.create!(user: other_user, link: @link, value: Vote::UP)

    assert_equal 2, @link.vote_total
  end
end
