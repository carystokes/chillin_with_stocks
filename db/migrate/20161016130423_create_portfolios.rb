class CreatePortfolios < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
      t.text :title, null: false
      t.decimal :cash
      t.belongs_to :user, null: false
    end
  end
end
