class RemoveGeospactialGeometry < ActiveRecord::Migration[7.1]
  def change
    remove_column :geospatial_data, :geometry
  end
end
