class AddPhotoAndVideoToNews < ActiveRecord::Migration
  def change
    add_column :news, :photo, :string
    add_column :news, :video, :string
  end
end
