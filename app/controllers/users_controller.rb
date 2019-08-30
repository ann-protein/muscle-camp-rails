class UsersController < ApplicationController
  def get_user_data
    @user = User.find(params[:id])

    if !@user.unsubscribed
      # 退会済みでない時にjsonを返す
      render status: 200, :json => @user
    else
      render status: 400
    end
  end

  def edit
    # 現在のプロフィールを返す
    @user = User.find(params[:id])
    render :json => @user
  end

  def create
    # 入力されたパラメータで保存
    @user = User.new(user_params)

    if @user.save
      render status: 200
    else
      render status: 400
    end
   end

  def update
    # editの後で入力された値で更新
    @user = User.find(user_params)

    if @user.update(user_params)
      render status: 200
    else
      render status: 400
    end
  end

  def destroy
    # 退会処理
    @user = User.find(params[:id])
    @user.update(unsubsribed: true)

    render status: 200
  end

  private
    def user_params
      params.require(:user).permit(:icon, :identity, :introduction, :name, :password, :unsubscribed)
    end
end
