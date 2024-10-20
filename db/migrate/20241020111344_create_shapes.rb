class CreateShapes < ActiveRecord::Migration[7.1]
  def change
    create_table :shapes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.geometry :geometry, geographic: true
      t.jsonb :custom_options

      t.timestamps
    end
  end
end
