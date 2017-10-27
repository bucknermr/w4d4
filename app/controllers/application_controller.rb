class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :current_user_owns_cat, :owner?

  def current_user
    return nil unless session[:session_token]
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def login!(user)
    session[:session_token] = user.session_token
  end

  def logged_in?
    !!current_user
  end

  def require_logged_in
    redirect_to new_session_url unless logged_in?
  end

  def require_logged_out
    redirect_to cats_url if logged_in?
  end

  def logout!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def current_user_owns_cat
    @cat = current_user.cats.find_by(id: params[:id])
    unless @cat
      flash[:errors] = ["CAT THIEF. nawwww jp but like you dont own dat cat cuz"]
      redirect_to cat_url(params[:id])
    end
  end

  def owner?
    !!current_user.cats.find_by(id: params[:id])
  end
end
