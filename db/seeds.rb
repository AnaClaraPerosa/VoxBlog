require 'parallel'
require 'securerandom'
require 'net/http'
require 'uri'
require 'json'

API_URL = 'http://localhost:3000'

def create_post_with_rating(user_login, ip, title, body, should_rate)
  post_params = {
    title: title,
    body: body,
    login: user_login,
    ip: ip
  }

  uri = URI("#{API_URL}/posts")
  res = Net::HTTP.post(uri, post_params.to_json, 'Content-Type' => 'application/json')
  return unless res.is_a?(Net::HTTPSuccess)

  post_data = JSON.parse(res.body)
  user_id = post_data.dig('user', 'id')
  post_id = post_data['id']

  if should_rate && user_id && post_id
    rating_value = rand(1..5)
    rating_params = {
      user_id: user_id,
      post_id: post_id,
      value: rating_value
    }

    uri = URI("#{API_URL}/ratings")
    Net::HTTP.post(uri, rating_params.to_json, 'Content-Type' => 'application/json')
  end
end

def generate_seeds_parallel(user_count: 100, post_count: 200_000, rating_probability: 0.75)
  puts "Gerando #{user_count} usuários, #{post_count} posts, e cerca de #{(post_count * rating_probability).to_i} avaliações..."

  user_logins = Array.new(user_count) { "user_#{SecureRandom.hex(3)}" }
  ips = Array.new(50) { "192.168.0.#{rand(1..254)}" }

  Parallel.each(1..post_count, in_threads: 20) do |i|
    user_login = user_logins.sample
    ip = ips.sample
    title = "Post #{i} - #{SecureRandom.hex(4)}"
    body = "Corpo do post #{i} - #{SecureRandom.hex(12)}"
    should_rate = rand < rating_probability

    create_post_with_rating(user_login, ip, title, body, should_rate)

    puts "Post #{i} criado com#{should_rate ? '' : 'out'} avaliação" if i % 1000 == 0
  end

  puts 'Seeds finalizados com sucesso!'
end


generate_seeds_parallel(user_count: 100, post_count: 200_000, rating_probability: 0.75)

