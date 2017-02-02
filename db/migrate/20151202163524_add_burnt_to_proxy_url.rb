class AddBurntToProxyUrl < ActiveRecord::Migration
  def change
    add_column :proxy_urls, :burnt, :boolean, default: false
  end
end
