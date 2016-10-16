class AddUserId < ActiveRecord::Migration
  def change
    add_column :portfolios, :user_id, :integer
    change_column_null :portfolios, :user_id, false
  end
end
