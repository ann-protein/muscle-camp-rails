class CreateMusclePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :muscle_posts do |t|
      t.text :body, null: false
      t.string :title, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
