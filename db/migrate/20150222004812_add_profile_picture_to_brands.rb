class AddProfilePictureToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :profile_picture, :string
  end
end
