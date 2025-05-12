class BatchCreatePostService
  def initialize(posts_data)
    @posts_data = posts_data
  end

  def call
    logins = @posts_data.map { |post| post[:login] }.uniq
    users = User.where(login: logins).index_by(&:login)

    missing_logins = logins - users.keys
    new_users = missing_logins.map { |login| { login: login, created_at: Time.current, updated_at: Time.current } }
    User.insert_all(new_users) if new_users.any?

    users = User.where(login: logins).index_by(&:login)

    posts = @posts_data.map do |post|
      {
        title: post[:title],
        body: post[:body],
        ip: post[:ip],
        user_id: users[post[:login]].id,
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    Post.insert_all!(posts)

    { success: true, created: posts.size }
  rescue => e
    { success: false, errors: [e.message] }
  end
end
