class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index,:edit, :update,:destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end
  def new
    @user = User.new
  end
  def show
    @user = User.find(params[:id])
  end
  def create
    @user = User.new(user_params)    # 実装は終わっていないことに注意!
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
      # reset_session
      # log_in @user  # ユーザーをログインさせる
      # flash[:success] = "Welcome to the Sample App!"
      # redirect_to @user  # ユーザーの作成に成功した場合、showアクションにリダイレクトします
      # 保存の成功をここで扱う。
    else
      render 'new', status: :unprocessable_entity
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  private
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
      # 更新に成功した場合を扱う
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
   # beforeフィルタ

    # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url, status: :see_other
    end
  end
  def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
  end
  def admin_user
      redirect_to(root_url, status: :see_other) unless current_user.admin?
    end
end
