class PostsController < ApplicationController
  def create
    result = CreatePostService.new(
      title: params[:title],
      body: params[:body],
      login: params[:login],
      ip: params[:ip]
    ).call

    if result[:success]
      render json: { post: result[:post], user: result[:user] }, status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def batch_create
    posts_params = params.permit(posts: [:title, :body, :login, :ip])[:posts]

    service = BatchCreatePostService.new(posts_params.map(&:to_h))
    result = service.call

    if result[:success]
      render json: { created: result[:created] }, status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def top
    n = params[:n].to_i

    top_posts = Post
                .select('posts.id, posts.title, posts.body, AVG(ratings.value) as avg_rating')
                .joins(:ratings)
                .group('posts.id')
                .order('avg_rating DESC')
                .limit(n)

    render json: top_posts
  end

  def ips
    posts = Post.includes(:user).select(:ip, :user_id)

    grouped = posts.group_by(&:ip).map do |ip, posts_with_ip|
      {
        ip: ip,
        logins: posts_with_ip.map { |post| post.user.login }.uniq
      }
    end

    render json: grouped
  end 
end
