class RatingsController < ApplicationController
  def create
    post_id = params[:post_id]
    user_id = params[:user_id]
    value = params[:value]

    if Rating.exists?(post_id: post_id, user_id: user_id)
      render json: { error: 'Usuário já avaliou este post' }, status: :unprocessable_entity
      return
    end

    rating = Rating.new(post_id: post_id, user_id: user_id, value: value)

    if rating.save
      average = Rating.where(post_id: post_id).average(:value).to_f.round(2)
      render json: { average_rating: average }, status: :created
    else
      render json: { errors: rating.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
