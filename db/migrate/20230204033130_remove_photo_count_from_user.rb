class RemovePhotoCountFromUser < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :photo_count, :integer
  end
end
