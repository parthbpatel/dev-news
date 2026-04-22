require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_user_path
    assert_response :success
  end

  test "creates a normalized user" do
    username = "  Charlie_#{unique_suffix}  "

    assert_difference('User.count', 1) do
      post users_path, params: { user: { username: username, password: 'password123' } }
    end

    assert_redirected_to root_path
    assert_equal username.strip.downcase, User.order(:created_at).last.username
  end
end
