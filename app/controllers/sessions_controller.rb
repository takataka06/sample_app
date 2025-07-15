class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])# authenticateメソッドはユーザーのパスワードを検証します
      forwarding_url = session[:forwarding_url]
      #ユーザーがデータベースにあり、かつ、認証に成功した場合にのみ
      reset_session # セッションをリセットしてセキュリティを強化
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      log_in user
      redirect_to forwarding_url || user# ログイン成功時にユーザープロフィールへリダイレクト
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in? # ログインしている場合はログアウト処理を実行
    redirect_to root_url, status: :see_other
  end
end
