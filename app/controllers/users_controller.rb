class UsersController < ApplicationController
  def get_user_data
    @user = User.find_by(identity: params[:identity])

    if @user.nil?
      # ユーザが見つからなかったとき
      render status: 404
    else
      if !@user.unsubscribed
        # 退会済み
        render status: 200, :json => @user
      else
        # 正常に見つかり、退会済みでないときjsonを返す
        render status: 400
      end
    end
  end

  def edit
    # 現在のプロフィールを返す
    @user = User.find_by(token: params[:token])
    if !@user.nil?
      render :json => @user
    else
      render status: 404
    end
  end

  def create
    # 入力されたパラメータで保存
    @user = User.new(user_params)

    if @user.save
      # 成功
      render status: 200
    else
      # 失敗
      render status: 400
    end
   end

  def update
    # editの後で入力された値で更新
    @user = User.find_by(token: params[:token])

    if @user.update(user_params)
      # 成功
      render status: 200
    else
      # 失敗
      render status: 400
    end
  end

  def destroy
    # 退会処理
    @user = User.find_by(token: params[:token])
    @user.update(unsubsribed: true)

    render status: 200
  end

  def login
    current_user = User.find_by(email: params[:email], password: params[:password])
    return render json: {message: '認証に失敗しました'}, status: 401 unless current_user

    response = {}
    response["token"] = current_user.token
    render json: response
  end

  private
    def user_params
      params.require(:user).permit(:icon, :identity, :introduction, :name, :password, :unsubscribed)
    end
end
