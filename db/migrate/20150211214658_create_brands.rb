class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name
      t.string :slug
      t.string :url

      t.timestamps null: false
    end

    add_index :brands, :slug
  end
end
