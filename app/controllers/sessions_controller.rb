class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])# authenticateメソッドはユーザーのパスワードを検証します
      #ユーザーがデータベースにあり、かつ、認証に成功した場合にのみ
      reset_session # セッションをリセットしてセキュリティを強化
      log_in user
      redirect_to user # ログイン成功時にユーザープロフィールへリダイレクト
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end
end
