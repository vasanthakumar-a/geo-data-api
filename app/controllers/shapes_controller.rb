class ShapesController < ApplicationController
  before_action :set_shape, only: [:show, :update, :destroy]

  # GET /shapes
  def index
    @shapes = Shape.all
    render json: @shapes
  end

  # GET /shapes/:id
  def show
    render json: @shape
  end

  # POST /shapes
  def create
    @shape = Shape.new(shape_params)
    if @shape.save
      render json: @shape, status: :created
    else
      render json: @shape.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shapes/:id
  def update
    if @shape.update(shape_params)
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
    @shape = Shape.find(params[:id])
  end

  def shape_params
    params.require(:shape).permit(:name, :geometry)
  end
end
