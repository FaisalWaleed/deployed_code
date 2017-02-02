class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :keyword
      t.string :target
      t.references :proxy_url
      t.references :browser
      t.boolean :burnt, default: false
      t.boolean :timeout, default: false

      t.timestamps
    end
    add_index :sessions, :proxy_url_id
    add_index :sessions, :browser_id
  end
end
