class Users::SessionsController < Devise::SessionsController
  respond_to :json
  before_action :clear_cache_act, only: [:create]

  def create
    user = User.find_for_database_authentication(email: params[:user][:email])
    if user&.valid_password?(params[:user][:password])
      token = current_user.generate_jwt
      render json: { message: 'Login successful', token: token, user: user }, status: :ok
    else
      render json: { errors: ['Invalid email or password'] }, status: :unauthorized
    end
  end

  def logout
    token = request.headers['Authorization'].split(' ').last if request.headers['Authorization'].present?
    if token
      decoded_token = JWT.decode(token, Rails.env.production? ? ENV['SECRET_KEY_BASE'] : Rails.application.credentials.secret_key_base).first
      jti = decoded_token
      user = User.find(jti["id"])
      JwtDenylist.create(jti: jti)
      if user.present?
        render json: { message: 'Logged out successfully' }, status: :ok
      else
        render json: { message: 'Already Logged out!' }, status: :unauthorized
      end
    end
  rescue JWT::DecodeError
    render json: { error: 'Invalid token' }, status: :unauthorized
  end

  private

  def respond_with(resource, _opts = {})
    render json: { message: 'Logged in successfully.', user: resource }, status: :ok
  end

  def clear_cache_act
    ActiveRecord::Base.connection.clear_cache!
    ActiveRecord::Base.connection.execute("DEALLOCATE ALL")
  end

  def respond_to_on_destroy
    token = request.headers['Authorization'].split(' ').last if request.headers['Authorization'].present?
    if token
      decoded_token = JWT.decode(token,Rails.env.production? ? ENV['SECRET_KEY_BASE'] : Rails.application.credentials.secret_key_base).first
      jti = decoded_token
      user = User.find(jti["id"])
      JwtDenylist.create(jti: jti)
      if user.present?
        render json: { message: 'Logged out successfully' }, status: :ok
      else
        render json: { message: 'Already Logged out!' }, status: :unauthorized
      end
    end
  rescue JWT::DecodeError
    render json: { error: 'Invalid token' }, status: :unauthorized
  end
end
