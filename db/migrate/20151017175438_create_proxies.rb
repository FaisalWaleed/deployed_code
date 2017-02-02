class CreateProxies < ActiveRecord::Migration
  def change
    create_table :proxies do |t|
      t.string :name
      t.string :provider_url
      t.text :comment

      t.timestamps
    end
  end
end
