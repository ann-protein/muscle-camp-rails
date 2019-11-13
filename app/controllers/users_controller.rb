class UsersController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :user_authentication, only: [:edit, :update, :destroy]

  def get_user_data
    user_row = User.find_by(identity: params[:identity])

    if user_row.nil?
      # ユーザが見つからなかったとき
      render :json => {"error_msg": "Not found"}, status: 404
    else
      if !user_row.unsubscribed
        # 正常に見つかり、退会済みでないときjsonを返す
        render :json => {'user': user_data_formation(user_row)}, status: 200
      else
        # 退会済み
        render status: 400
      end
    end
  end

  def edit
    # 現在のプロフィールを返す
    render :json => @user
  end

  def create
    # 入力されたパラメータを保存できる形に変換
    acounnt_json = account_params.to_hash
    user_hash = acounnt_json["account"]["user"]
    user_hash["password"] = acounnt_json["account"]["password"]
    @user = User.new(user_hash)

    if @user.save
      # 成功
      render status: 200, json: {'massage': 'Success create user'}
    else
      # 失敗
      render status: 400
    end
   end

  def update
    # editの後で入力された値で更新
    if @user.update(user_params)
      # 成功
      render status: 200, json: {'massage': 'Success create user'}
    else
      # 失敗
      render status: 400
    end
  end

  def destroy
    # 退会処理
    @user.unsubscribed = true
    if @user.save
      # 成功
      render status: 200, json: {'message': 'Success create user'}
    else
      # 失敗
      render status: 400
    end
  end

  def login
    current_user = User.find_by(email: params[:email])
    if current_user && !current_user.unsubscribed && current_user.authenticate(params[:password])
      current_user.token = create_token
      if current_user.save!(:validate => false)
        return render json: { token: current_user.token }, status: 200
      end
    end

    return render json: {message: '認証に失敗しました'}, status: 401
  end

  ## ランダム文字列を作る
  def create_token
    return ((0..9).to_a + ("a".."z").to_a + ("A".."Z").to_a).sample(24).join
  end

  def user_authentication
    # get `@user` by token
    authenticate_with_http_token do |token, options|
      @user = User.find_by(token: token)
      return render :json => {'error_msg':'Access denied'}, status: :unauthorized if @user.nil?
    end

    # token dosen't exist
    unless @user.present?
      return render :json => {'error_msg':'Access denied, need token'}, status: :unauthorized
    end
  end

  private
    def user_params
      params.require(:user).permit(:icon, :identity, :introduction, :name, :email, :unsubscribed)
    end

    def account_params
      params.permit(account:[:password, user:[:icon, :identity, :introduction, :name, :email]])
    end

    def user_data_formation(user)
      user_data_hash = {}
      user_data_hash[:icon] = user.icon
      user_data_hash[:identity] = user.identity
      user_data_hash[:introduction] = user.introduction
      user_data_hash[:name] = user.name
      user_data_hash[:email] = user.email

      return  user_data_hash
    end
end
