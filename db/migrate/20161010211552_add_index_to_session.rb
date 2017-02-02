class AddIndexToSession < ActiveRecord::Migration
  def change
    add_index :sessions, :product_id
  end
end
