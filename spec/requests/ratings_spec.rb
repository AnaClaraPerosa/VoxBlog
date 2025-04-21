RSpec.describe 'Ratings API', type: :request do
  describe 'POST /ratings' do
    let!(:user) { User.create!(login: 'user1') }
    let!(:post_record) { Post.create!(title: 'Post', body: 'Body', user: user, ip: '1.1.1.1') }

    it 'cria uma avaliação se ainda não houver uma do mesmo usuário' do
      post '/ratings', params: { post_id: post_record.id, user_id: user.id, value: 4 }
      expect(response).to have_http_status(:created)
      expect(response.parsed_body['average_rating']).to eq(4.0)
    end

    it 'impede avaliação duplicada por mesmo usuário' do
      Rating.create!(post: post_record, user: user, value: 5)
      post '/ratings', params: { post_id: post_record.id, user_id: user.id, value: 3 }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body['error']).to include('já avaliou')
    end
  end
end
