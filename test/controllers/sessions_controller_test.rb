require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(username: "alice_#{unique_suffix}", password: 'password123')
  end

  test "should get new" do
    get new_session_path
    assert_response :success
  end

  test "logs in with a case insensitive username" do
    post session_path, params: { session: { username: @user.username.upcase, password: 'password123' } }

    assert_redirected_to root_path

    get new_link_path
    assert_response :success
  end

  test "logs out with delete" do
    sign_in_as(@user)

    delete session_path

    assert_redirected_to root_path

    get new_link_path
    assert_redirected_to new_session_path
  end
end
