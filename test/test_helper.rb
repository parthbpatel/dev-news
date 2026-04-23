require 'securerandom'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  def sign_in_as(user, password: 'password123')
    post session_path, params: { session: { username: user.username, password: password } }
  end

  def unique_suffix
    SecureRandom.hex(4)
  end
end
