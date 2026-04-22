require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    suffix = unique_suffix
    @alice = User.create!(username: "alice_#{suffix}", password: 'password123')
    @bob = User.create!(username: "bob_#{suffix}", password: 'password123')
    @alice_link = @alice.links.create!(title: "Rails Guide #{suffix}", url: 'https://rubyonrails.org', description: 'Official Ruby on Rails documentation.')
    @alice_comment = @alice.comments.create!(link: @alice_link, body: 'First comment')
  end

  test "should get index" do
    get comments_path
    assert_response :success
  end

  test "paginates comments five at a time" do
    6.times do |index|
      @bob.comments.create!(link: @alice_link, body: "Sitewide comment #{index}")
    end

    get comments_path

    assert_response :success
    assert_select '.comment', 5
    assert_select '.infinite-scroll-loader[data-next-url]', 1

    get comments_path(page: 2), xhr: true

    assert_response :success
    assert_select '.comment', 2
  end

  test "requires login to create a comment" do
    assert_no_difference('Comment.count') do
      post link_comments_path(@alice_link), params: { comment: { body: 'This should not save' } }
    end

    assert_redirected_to new_session_path
  end

  test "owner can update a comment" do
    sign_in_as(@alice)

    patch link_comment_path(@alice_link, @alice_comment), params: { comment: { body: 'Updated comment body' } }

    assert_redirected_to link_path(@alice_link)
    assert_equal 'Updated comment body', @alice_comment.reload.body
  end

  test "non owner cannot update a comment" do
    sign_in_as(@bob)

    patch link_comment_path(@alice_link, @alice_comment), params: { comment: { body: 'Not allowed' } }

    assert_redirected_to link_path(@alice_link)
    assert_equal 'First comment', @alice_comment.reload.body
  end
end
