class CreateTagMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :tag_maps do |t|
      t.references :body_part, foreign_key: true
      t.references :muscle_post, foreign_key: true

      t.timestamps
    end
  end
end
