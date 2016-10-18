class AddHoldings < ActiveRecord::Migration
  def change
    create_table :holdings do |t|
      t.string :symbol, null: false
      t.integer :number_shares, default: 0
      t.decimal :purchase_price, default: 0
      t.belongs_to :portfolio, null: false
    end
  end
end
