class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, except: :destroy
  before_action :require_login, only: :destroy

  def new
  end

  def create
    user = User.find_by_normalized_username(login_params[:username])

    if user && user.authenticate(login_params[:password])
      login(user)
      redirect_to root_path, notice: 'Logged in'
    else
      flash.now[:notice] = 'Invalid username / password combination'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: 'Logged out', status: :see_other
  end

  private

  def login_params
    params.require(:session).permit(:username, :password)
  end
end
