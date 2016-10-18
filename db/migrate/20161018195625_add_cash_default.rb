class AddCashDefault < ActiveRecord::Migration
  def change
    change_column_default :portfolios, :cash, 0.0
  end
end
