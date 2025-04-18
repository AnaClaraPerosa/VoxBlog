class RatingsController < ApplicationController
    def create
        result = RatePostServices.new(
            post_id: params[:post_id],
            user_id: params[:user_id],
            value: params[:value]
        ).call

        if result[:success]
            render json: { average_rating: result[:average] }, status: :created
        else
            render json: { errors: result[:errors] }, status: :unprocessable_entity
        end
    end
end
