class AddIndexes < ActiveRecord::Migration
  def change
    add_index :sessions, :failure_reason
    add_index :sessions, :updated_at

    add_column :sessions, :page, :integer, default: 0
    add_index :sessions, :page
  end
end
