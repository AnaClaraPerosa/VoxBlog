require 'rails_helper'

RSpec.describe 'Posts API', type: :request do
  describe 'POST /posts' do
    let(:valid_params) do
      {
        title: 'Post Title',
        body: 'Post Body',
        login: 'new_user',
        ip: '123.123.123.123'
      }
    end

    it 'cria um post e um usuário se ele não existir' do
      expect do
        post '/posts', params: valid_params
      end.to change(Post, :count).by(1).and change(User, :count).by(1)

      expect(response).to have_http_status(:created)
      json = response.parsed_body
      expect(json['post']['title']).to eq('Post Title')
      expect(json['user']['login']).to eq('new_user')
    end

    it 'retorna erro se dados forem inválidos' do
      post '/posts', params: valid_params.merge(title: '')
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body['errors']).to be_present
    end
  end

  describe 'GET /posts/top' do
    it 'retorna os N melhores posts por média de avaliação' do
      user = User.create!(login: 'topuser')
      post1 = Post.create!(title: 'Post 1', body: 'Body 1', user: user, ip: '1.1.1.1')
      post2 = Post.create!(title: 'Post 2', body: 'Body 2', user: user, ip: '1.1.1.2')
      Rating.create!(post: post1, user: user, value: 5)
      Rating.create!(post: post2, user: user, value: 3)

      get '/posts/top', params: { n: 1 }
      expect(response).to have_http_status(:ok)
      json = response.parsed_body
      expect(json.length).to eq(1)
      expect(json.first['title']).to eq('Post 1')
    end
  end

  describe 'GET /posts/ips' do
    it 'retorna os IPs com os logins dos autores' do
      user1 = User.create!(login: 'alice')
      user2 = User.create!(login: 'bob')
      Post.create!(title: 'A', body: 'A', user: user1, ip: '10.0.0.1')
      Post.create!(title: 'B', body: 'B', user: user2, ip: '10.0.0.1')

      get '/posts/ips'
      expect(response).to have_http_status(:ok)
      json = response.parsed_body
      expect(json).to include({ 'ip' => '10.0.0.1', 'logins' => match_array(%w[alice bob]) })
    end
  end
end
