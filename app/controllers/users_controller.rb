class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to '/'
    else
      render 'new'
    end
  end

  def logout
    session.clear
    redirect_to '/'
  end

  def login
    @user = User.new
  end

  def create_session
    @user = User.find_by(email: params[:user][:email])

    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect_to @user
    else
      @user = User.new
      @user.errors.add(:invalid, "Email or Password")
      render "login"
    end
  end


  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
