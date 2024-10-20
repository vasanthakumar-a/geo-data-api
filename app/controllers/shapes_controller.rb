class ShapesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shape, only: [:show, :update, :destroy]

  # GET /shapes
  def index
    @shapes = current_user.shapes.order("updated_at DESC")
    render json: @shapes
  end

  # GET /shapes/:id
  def show
    render json: @shape
  end

  # POST /shapes
  def create
    @shape = Shape.new(build_shape_params)
    if @shape.save
      render json: @shape, status: :created
    else
      render json: @shape.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shapes/:id
  def update
    if @shape.update(build_shape_params)
      render json: @shape
    else
      render json: @shape.errors, status: :unprocessable_entity
    end
  end

  # DELETE /shapes/:id
  def destroy
    @shape.destroy
    head :no_content
  end

  private

  def set_shape
    @shape = current_user.shapes.find_by(id: params[:id])
  end

  def build_shape_params
    geojson_data = params[:shape][:geometry]
    factory = RGeo::Geographic.spherical_factory(srid: 4326)
    rgeo_geometry = factory.parse_geojson(geojson_data.to_json)
    {
      user_id: current_user.id,
      name: params[:shape][:name],
      geometry: rgeo_geometry,
      custom_options: params[:shape][:custom_options] || {}
    }
  end

  def shape_params
    params.require(:shape).permit(:name, :geometry)
  end
end
