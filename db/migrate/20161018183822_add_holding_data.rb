class AddHoldingData < ActiveRecord::Migration
  def change
    add_column :holdings, :price_close, :decimal
    add_column :holdings, :div_yield, :decimal
    add_column :holdings, :year_target, :decimal
    add_column :holdings, :year_high, :decimal
    add_column :holdings, :year_low, :decimal
    add_column :holdings, :market_cap, :text
    add_column :holdings, :avg_volume, :integer
    add_column :holdings, :eps_current, :decimal
    add_column :holdings, :eps_next, :decimal
    add_column :holdings, :short_ratio, :decimal
  end
end
