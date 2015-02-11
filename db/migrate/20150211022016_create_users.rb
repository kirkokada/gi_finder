class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.float :height
      t.float :weight
      t.string :username
      t.string :email
      t.boolean :admin, default: false

      t.timestamps null: false
    end

    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end
