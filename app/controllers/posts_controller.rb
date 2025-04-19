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
    data = Post
           .joins(:user)
           .select('posts.ip, user.login')
           .group_by(&:ip)
           .map do |ip, posts|
      {
        ip: ip,
        logins: posts.map(&:login).uniq
      }
    end

    render json: data
  end
end
