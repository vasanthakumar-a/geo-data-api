class ApplicationController < ActionController::API

  private

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    if token
      begin
        decoded_token = JWT.decode(token, Rails.env.production? ? ENV['SECRET_KEY_BASE'] : Rails.application.credentials.secret_key_base).first
        @current_user = User.find(decoded_token['id']) unless @current_user.present?
      rescue JWT::DecodeError
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    else
      render json: { error: 'Token missing' }, status: :unauthorized
    end
  end
end
