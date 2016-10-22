class AddChillPointsTotal < ActiveRecord::Migration
  def change
    add_column :holdings, :chill_points, :integer, default: 0
    add_column :holdings, :chill_color, :text
    add_column :holdings, :chill_message, :text
  end
end
