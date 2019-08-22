class CreateBodyParts < ActiveRecord::Migration[5.2]
  def change
    create_table :body_parts do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :body_parts, :name, unique: true
  end
end
