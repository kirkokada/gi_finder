class AddInstagramUsernameToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :instagram_username, :string
  end
end
