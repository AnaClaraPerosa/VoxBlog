class RatePostService
    def initialize(post_id:, user_id:, value:)
        @post_id = post_id
        @user_id = user_id
        @value = value
    end
  
    def call
        rating = Rating.new(post_id: @post_id, user_id: @user_id, value: @value)
  
        if rating.save
            avg = Rating.where(post_id: @post_id).average(:value).to_f.round(2)
            { success: true, average: avg }
        else
            { success: false, errors: rating.errors.full_messages }
        end
    end
end
  