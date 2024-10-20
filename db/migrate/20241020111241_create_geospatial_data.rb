class CreateGeospatialData < ActiveRecord::Migration[7.1]
  def change
    create_table :geospatial_data do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :file_type
      t.geometry :geometry, geographic: true

      t.timestamps
    end
  end
end
