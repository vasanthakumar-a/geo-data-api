class GeospatialDataController < ApplicationController
  # before_action :authenticate_user!

  def create
    @geospatial_data = current_user.geospatial_data.new(geospatial_data_params)
    @geospatial_data.build_shape({user_id: current_user.id, name: 'file name', geometry: '', custom_options: {}})
    if @geospatial_data.save
      render json: { success: true, data: @geospatial_data }, status: :created
    else
      render json: { errors: @geospatial_data.errors }, status: :unprocessable_entity
    end
  end

  def index
    @geospatial_data = current_user.geospatial_data
    render json: @geospatial_data
  end

  private
  def geospatial_file_permit
    params.require(:geospatial_data).permit(:file)
  end

  def geospatial_data_params
    params.require(:geospatial_data).permit(:name, :file_type)
  end
end
