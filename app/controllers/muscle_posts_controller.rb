class MusclePostsController < ApplicationController
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
    render :json => responses.to_json
  end

  def create_muscle_post
    # パラメータを検証
    unless params[:identity].is_a? String
      render :json => {"error_msg":"value for key 'identity' should be a string"}, status: 422 and return
    end
    unless params[:body_parts].is_a? Array and params[:body_parts].all? { |x| x.is_a? String }
      render :json => {"error_msg":"value for key 'body_parts' should be an array of string"}, status: 422 and return
    end

    # userの存在を検証
    user = User.find_by(identity: params[:identity])
    if user.nil?
      render :json => {"error_msg":"User dont exist"}, status: 422 and return
    end

    # Create MusclePost without committing
    muscle_post = user.muscle_posts.new(muscle_post_params)

    # body_partsの存在を検証
    if params.has_key?(:body_parts)
      body_parts = BodyPart.where(name: params[:body_parts])
      unless body_parts.pluck(:name).sort == params[:body_parts].sort
        render :json => {"error_msg":"body_parts data false"}, status: 422 and return
      end
      muscle_post.body_parts << body_parts
    end

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
    params.permit(:title,:body)
  end

end
