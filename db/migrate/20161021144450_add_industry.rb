class AddIndustry < ActiveRecord::Migration
  def change
    add_column :holdings, :industry, :text
  end
end
