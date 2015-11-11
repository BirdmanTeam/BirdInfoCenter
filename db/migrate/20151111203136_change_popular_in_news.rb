class ChangePopularInNews < ActiveRecord::Migration
  def change
   change_column_default :news, :popular, false
  end
end
