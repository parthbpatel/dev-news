require 'test_helper'

class LinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    suffix = unique_suffix
    @alice = User.create!(username: "alice_#{suffix}", password: 'password123')
    @bob = User.create!(username: "bob_#{suffix}", password: 'password123')
    @alice_link = @alice.links.create!(title: "Rails Guide #{suffix}", url: 'https://rubyonrails.org', description: 'Official Ruby on Rails documentation.')
    @bob_link = @bob.links.create!(title: "Hotwire Handbook #{suffix}", url: 'https://hotwired.dev', description: 'Hotwire reference material.')
  end

  test "should get index" do
    get root_path
    assert_response :success
  end

  test "should get newest without authentication" do
    get newest_path
    assert_response :success
  end

  test "paginates links eight at a time" do
    10.times do |index|
      @alice.links.create!(title: "Extra Link #{unique_suffix}-#{index}", url: "https://example.com/links/#{index}", description: 'More reading')
    end

    get root_path

    assert_response :success
    assert_select '.link', 8
    assert_select '.infinite-scroll-loader[data-next-url]', 1
  end

  test "loads additional links over xhr" do
    10.times do |index|
      @alice.links.create!(title: "XHR Link #{unique_suffix}-#{index}", url: "https://example.com/xhr/#{index}", description: 'Next page')
    end

    get root_path(page: 2), xhr: true

    assert_response :success
    assert_select '.link', 4
    assert_select '.infinite-scroll-page', 1
  end

  test "requires login to create a link" do
    assert_no_difference('Link.count') do
      post links_path, params: { link: { title: 'Fresh link', url: 'https://example.com', description: 'A good read' } }
    end

    assert_redirected_to new_session_path
  end

  test "owner can update a link" do
    sign_in_as(@alice)

    patch link_path(@alice_link), params: { link: { title: 'Updated Rails Guide', url: @alice_link.url, description: @alice_link.description } }

    assert_redirected_to link_path(@alice_link)
    assert_equal 'Updated Rails Guide', @alice_link.reload.title
  end

  test "non owner cannot update a link" do
    sign_in_as(@bob)

    patch link_path(@alice_link), params: { link: { title: 'Not allowed' } }

    assert_redirected_to root_path
    assert_equal @alice_link.title, @alice_link.reload.title
  end

  test "logged in user can toggle an upvote" do
    sign_in_as(@alice)

    assert_difference('Vote.count', 1) do
      post upvote_link_path(@bob_link)
    end

    assert_redirected_to link_path(@bob_link)
    assert @alice.reload.upvoted?(@bob_link)
    assert_equal 1, @bob_link.reload.points
  end

  test "paginates link comments five at a time" do
    7.times do |index|
      @bob.comments.create!(link: @alice_link, body: "Paged comment #{index}")
    end

    get link_path(@alice_link)

    assert_response :success
    assert_select '.comment', 5
    assert_select '.infinite-scroll-loader[data-next-url]', 1

    get link_path(@alice_link, page: 2), xhr: true

    assert_response :success
    assert_select '.comment', 2
  end
end
