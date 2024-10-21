class AddShapeToGeospatial < ActiveRecord::Migration[7.1]
  def change
    add_reference :geospatial_data, :shape, null: true, foreign_key: true
  end
end
