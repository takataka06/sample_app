class UsersController < ApplicationController
  def new
    @user = User.new
  end
  def show
    @user = User.find(params[:id])
  end
  def create
    @user = User.new(user_params)    # 実装は終わっていないことに注意!
    if @user.save
      reset_session
      log_in @user  # ユーザーをログインさせる
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user  # ユーザーの作成に成功した場合、showアクションにリダイレクトします
      # 保存の成功をここで扱う。
    else
      render 'new', status: :unprocessable_entity
    end
  end
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
