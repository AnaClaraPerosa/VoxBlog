class CreatePostService
  def initialize(title:, body:, login:, ip:)
    @title = title
    @body = body
    @login = login
    @ip = ip
  end

  def call
    user = User.find_or_create_by!(login: @login)
    post = Post.new(title: @title, body: @body, ip: @ip, user: user)

    if post.save
      { success: true, post: post, user: user }
    else
      { success: false, errors: post.errors.full_messages }
    end
  end
end
