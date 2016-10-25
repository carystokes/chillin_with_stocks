class AddMarketCapNum < ActiveRecord::Migration
  def change
    add_column :holdings, :market_cap_num, :decimal
  end
end
