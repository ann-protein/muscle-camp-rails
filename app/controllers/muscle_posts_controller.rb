class MusclePostsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :user_authentication, only: [:create_muscle_post]
  def timeline
    # 要求数取得
    limit = params[:limit]

    # 新着順に投稿IDを取得
    muscle_post_id_ary = MusclePost.order(created_at: :desc)
                          .limit(limit)
                          .pluck(:id)

    # データを取得
    result = MusclePost.where(id: muscle_post_id_ary)
                 .joins(tag_maps: :body_part)
                 .joins(:user)
                 .select("users.icon, users.identity, users.name, muscle_posts.*, body_parts.name")

    # 整形
    temp_hash = muscle_post_data_formation(result)
    responses = []
    for muscle_post_id in muscle_post_id_ary
      responses.push(temp_hash[muscle_post_id])
    end

    # レスポンスを返す
    render :json => responses.to_json
  end

  def get_muscle_post
    # id取得
    muscle_post_id = params[:id]

    # データを取得
    result = MusclePost.where(id: muscle_post_id)
                 .joins(tag_maps: :body_part)
                 .joins(:user).select("users.icon, users.identity, users.name, muscle_posts.*, body_parts.name")

    # データ存在しないとき、[]を返す
    if result.blank?
      render :json => [], :status => 404
      return
    end

    # 整形
    temp_hash = muscle_post_data_formation(result)
    responses = [temp_hash[muscle_post_id.to_i]]

    # レスポンスを返す
    render :json => {"muscle_posts": responses.to_json}
  end

  def create_muscle_post
    # パラメータを検証
    _body_parts = params[:muscle_post][:body_parts]
    unless _body_parts.is_a? Array and _body_parts.all? { |x| x.is_a? String }
      render :json => {"error_msg":"value for key 'body_parts' should be an array of string"}, status: 422 and return
    end

    # Create MusclePost without committing
    muscle_post = @user.muscle_posts.new(muscle_post_params)

    db_body_parts = BodyPart.where(name: _body_parts)
    db_body_parts_name = db_body_parts.pluck(:name)

    unless (_body_parts - db_body_parts_name).empty?
      render :json => {"error_msg":"body_parts data false"}, status: 422 and return
    end

    muscle_post.body_parts = db_body_parts

    # MusclePostのデータを検証
    unless muscle_post.save
      render :json => {'error_msg':"MusclePost data false,you should check 'title' and 'body'"}, status: 422 and return
    end

    render :json => {"result":true}
  end

  private
  # データ整形
  def muscle_post_data_formation(result)
    temp_hash = {}
    for r in result
      if temp_hash.has_key?(r.id)
        temp_hash[r.id]['body_parts'].push(r.name)
        next
      end
      temp_hash[r.id] = {}
      temp_hash[r.id]['icon'] = r.icon
      temp_hash[r.id]['identity'] = r.identity
      temp_hash[r.id]['name'] = r.user.name
      temp_hash[r.id]['title'] = r.title
      temp_hash[r.id]['body'] = r.body
      temp_hash[r.id]['body_parts'] = [r.name]
    end
    temp_hash
  end

  def muscle_post_params
    params.require('muscle_post').permit(:title, :body)
  end

  def user_authentication
    # get `@user` by token
    authenticate_with_http_token  do |token, options|
      @user = User.find_by(token: token)
      return render :json => {'error_msg':'Access denied'}, status: :unauthorized if @user.nil?
    end

    # token dosen't exist
    unless @user.present?
      return render :json => {'error_msg':'Access denied, need token'}, status: :unauthorized
    end
  end

end
