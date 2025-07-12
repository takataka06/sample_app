class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      reset_session # セッションをリセットしてセキュリティを強化
      log_in user
      redirect_to user # ログイン成功時にユーザープロフィールへリダイレクト
      # authenticateメソッドはユーザーのパスワードを検証します
      #ユーザーがデータベースにあり、かつ、認証に成功した場合にのみ
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
  end
end
