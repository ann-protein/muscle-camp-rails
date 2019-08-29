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
                 .select("muscle_posts.*, body_parts.name")
                 .joins(:user)
                 .select("users.icon, users.identity, users.name, muscle_posts.*, body_parts.name")

    # 整形
    temp_hash = {}
    for r in result
     if temp_hash.has_key?(r.id)
        temp_hash[r.id]['body_parts'].push(r.name)
        next
      end
      temp_hash[r.id] = {}
      temp_hash[r.id] = {}
      temp_hash[r.id]['icon'] = r.icon
      temp_hash[r.id]['identity'] = r.identity
      temp_hash[r.id]['name'] = r.user.name
      temp_hash[r.id]['title'] = r.title
      temp_hash[r.id]['body'] = r.body
      temp_hash[r.id]['body_parts'] = [r.name]
    end

    responses = []
    for muscle_post_id in muscle_post_id_ary
      responses.push(temp_hash[muscle_post_id])
    end

    # レスポンスを返す
    render :json => responses.to_json
  end
end
