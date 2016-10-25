class AddPortfolioChillData < ActiveRecord::Migration
  def change
    add_column :portfolios, :portfolio_chill_points, :integer, default: 0
    add_column :portfolios, :portfolio_chill_color, :text
    add_column :portfolios, :portfolio_chill_message, :text
  end
end
