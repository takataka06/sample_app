module SessionsHelper
  def current_user
    if (user_id = session[:user_id])
      user = User.find_by(id: user_id)
      @current_user ||= user if session[:session_token] == user.session_token
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  def log_in(user)
    session[:user_id] = user.id
    session[:session_token] = user.session_token
  end
  def logged_in?
    !current_user.nil?
  end
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil   # 安全のため
  end
  # 永続的セッションのためにユーザーをデータベースに記憶する
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  def current_user?(user)
    user && user == current_user
  end
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
