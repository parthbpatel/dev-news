class ApplicationController < ActionController::Base
  include Pagy::Backend

  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def login(user)
    reset_session
    session[:user_id] = user.id
  end

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = session[:user_id].present? ? User.find_by(id: session[:user_id]) : nil
  end

  def logout
    reset_session
    @current_user = nil
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    redirect_to new_session_path, notice: 'Please log in to continue', status: :see_other unless logged_in?
  end

  def redirect_if_authenticated
    redirect_to root_path, notice: 'You are already logged in', status: :see_other if logged_in?
  end

  def render_not_found
    redirect_to root_path, notice: "We couldn't find that record", status: :see_other
  end
end
