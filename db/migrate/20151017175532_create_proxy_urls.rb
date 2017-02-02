class CreateProxyUrls < ActiveRecord::Migration
  def change
    create_table :proxy_urls do |t|
      t.string :ip
      t.integer :port
      t.references :proxy

      t.timestamps
    end
  end
end
