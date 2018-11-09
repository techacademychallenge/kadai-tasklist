class UsersController < ApplicationController
  before_action :require_user_logged_in, only:[:index, :show]
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    require_current_user_logged_in(@user)
    @tasks = @user.tasks.page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(users_params)
    if @user.save
      flash[:success] = "ユーザを登録しました。"
      redirect_to @user
    else
      flash.now[:danger] = "ユーザの登録に失敗しました。"
      render :new
    end
    
  end
  
  private
  
  def users_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def require_current_user_logged_in(user)
    unless current_user == user
      redirect_to root_url
    end
  end
end
