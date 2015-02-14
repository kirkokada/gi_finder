class CreateSizes < ActiveRecord::Migration
  def change
    create_table :sizes do |t|
      t.integer :brand_id, default: 0
      t.string :name,      default: ''
      t.float :max_height, default: 0
      t.float :min_height, default: 0
      t.float :max_weight, default: 0
      t.float :min_weight, default: 0

      t.timestamps null: false
    end

    add_index :sizes, :brand_id
  end
end
