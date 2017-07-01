module SessionsHelper

  def current_user
    if session[:id]
      User.find(session[:id])
    end
  end

  def require_user
    redirect "/login" unless current_user
  end

  def logged_in?
    !!current_user
  end
  
end
