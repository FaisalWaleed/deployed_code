class AddSessionRateToProduct < ActiveRecord::Migration
  def change
    add_column :products, :session_rate, :integer, default: 0
  end
end
