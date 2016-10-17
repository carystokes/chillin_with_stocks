class AddHoldings < ActiveRecord::Migration
  def change
    create_table :holdings do |t|
      t.string :symbol, null: false
      t.integer :number_shares
      t.decimal :purchase_price
      t.belongs_to :portfolio, null: false
    end
  end
end
