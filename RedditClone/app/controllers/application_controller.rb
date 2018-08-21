class ApplicationController < ActionController::Base

  helper_method :current_user, :logged_in?

  def login!(user)
    @current_user = user
    user.reset_session_token!
    session[:session_token] = user.session_token
  end

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def logout!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def logged_in?
    !!current_user
  end

  def require_login
     # redirect_to something unless logged_in? TODO
 end
end
