class SessionsController < ApplicationController
include sessionsHelper
  def new 
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email])
      session[:user_id] = @user.user_idredirect_to user_path(@user)
    else
      @errors = ["invalid Email or Password"]
      render "new"
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end
end
