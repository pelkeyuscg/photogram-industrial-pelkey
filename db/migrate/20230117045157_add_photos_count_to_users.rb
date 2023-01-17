class AddPhotosCountToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :photo_count, :integer
  end
end
