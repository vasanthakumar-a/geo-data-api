class GeospatialDataController < ApplicationController
  before_action :authenticate_user!

  def create

    file = params[:file]
    file_name = File.basename(file.original_filename, File.extname(file.original_filename))
    file_extension = File.extname(file.original_filename).delete('.').downcase

    @geospatial_data = current_user.geospatial_data.new({name: file_name, file: params[:file], file_type: file_extension})
    @geospatial_data.build_shape(build_shape_params)

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

  def build_shape_params
    file = params[:file]
    file_name = File.basename(file.original_filename, File.extname(file.original_filename))
    file_extension = File.extname(file.original_filename).delete('.').downcase

    geojson_data = JSON.parse(file.read)
    geo_factory = RGeo::Geographic.spherical_factory(srid: 4326)
    rgeo_geometry = geo_factory.parse_geojson(geojson_data)

    {
      user_id: current_user.id,
      name: "#{file_name} - #{file_extension.downcase} Type",
      geometry: rgeo_geometry,
      custom_options: {}
    }
  end

  def geospatial_data_params
    params.require(:geospatial_data).permit(:name, :file_type)
  end
end
