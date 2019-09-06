class MusclePostsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :user_authentication, only: [:create_muscle_post,:update_muscle_post,:destroy_muscle_post]
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
    muscle_posts = muscle_post_data_formation(result)
    responses = []
    for muscle_post_id in muscle_post_id_ary
      responses.push(muscle_posts[muscle_post_id])
    end

    # レスポンスを返す
    render :json => {"muscle_posts": responses}
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
      render :json => {"error_msg": "Not found"}, :status => 404
      return
    end

    # 整形
    muscle_posts = muscle_post_data_formation(result)
    responses = muscle_posts[muscle_post_id.to_i]

    # レスポンスを返す
    render :json => {"muscle_post": responses}
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

    render :json => {'massage':'Success'}
  end

  def update_muscle_post
    _body_parts = params[:muscle_post][:body_parts]
    # パラメータを検証
    unless _body_parts.is_a? Array and _body_parts.all? { |x| x.is_a? String }
      render :json => {"error_msg":"value for key 'body_parts' should be an array of string"}, status: 422 and return
    end

    # MusclePostを取得
    begin
      muscle_post = @user.muscle_posts.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      return render :json => {"error_msg":"user dont have MusclePost[id=#{params[:id]}]"}, status: 403
    end

    # body_partsの存在を検証
    body_parts = BodyPart.where(name: _body_parts)
    unless body_parts.pluck(:name).sort == _body_parts.sort
      render :json => {"error_msg":"body_parts data false"}, status: 403 and return
    end
    muscle_post.body_parts = body_parts

    # MusclePostを更新
    muscle_post.update(muscle_post_params)

    # MusclePostのデータを検証
    return render :json => {'error_msg':"MusclePost data false,you should check 'title' and 'body'"}, status: 422 unless muscle_post.save

    render :json => {'massage':'Success'}
  end

  def destroy_muscle_post
    # MusclePostを取得
    begin
      muscle_post = @user.muscle_posts.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      return render :json => {"error_msg":"user dont have MusclePost[id=#{params[:id]}]"}, status: 403
    end

    muscle_post.destroy

    render :json => {'massage':'Success'}
  end

  private
  # データ整形
  def muscle_post_data_formation(result)
    muscle_posts = {}
    for r in result
      if muscle_posts.has_key?(r.id)
        muscle_posts[r.id][:muscle_post_body][:body_parts].push(r.name)
        next
      end
      muscle_posts[r.id] = {}
      muscle_posts[r.id][:muscle_post_body] = {}
      muscle_posts[r.id][:id] = r.id
      muscle_posts[r.id][:icon] = r.icon
      muscle_posts[r.id][:identity] = r.identity
      muscle_posts[r.id][:name] = r.user.name
      muscle_posts[r.id][:muscle_post_body][:title] = r.title
      muscle_posts[r.id][:muscle_post_body][:body] = r.body
      muscle_posts[r.id][:muscle_post_body][:body_parts] = [r.name]
    end
    muscle_posts
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
