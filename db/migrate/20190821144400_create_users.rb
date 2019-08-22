class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.text :icon, null: false
      t.string :identity, null: false
      t.text :introduction, null: false
      t.string :name, null: false
      t.string :password, null: false
      t.boolean :unsubscribed, null: false

      t.timestamps
    end

    add_index :users, :identity, unique: true
  end
end
