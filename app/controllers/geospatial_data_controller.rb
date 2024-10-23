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
    file_content = File.read(file.tempfile)
    file_name = File.basename(file.original_filename, File.extname(file.original_filename))
    file_extension = File.extname(file.original_filename).delete('.').downcase
    wkt_geometry = ''
    factory = RGeo::Geographic.spherical_factory(srid: 4326)

    if(file_extension == "json")
      geojson_data = JSON.parse(file_content)
      wkt_geometry = factory.parse_geojson(geojson_data)
    elsif(file_extension == "kml")
      wkt_polygon = Shape.kml_to_wkt(file_content)
      kml_geometry = wkt_polygon
      wkt_geometry = factory.parse_wkt(kml_geometry)
    else
      wkt_geometry = ''
    end

    {
      user_id: current_user.id,
      name: "#{file_name} - #{file_extension.downcase} Type",
      geometry: wkt_geometry,
      custom_options: {}
    }
  end

  def geospatial_data_params
    params.require(:geospatial_data).permit(:name, :file_type)
  end
end
