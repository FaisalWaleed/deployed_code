class RemoveReferralUrlsFromProduct < ActiveRecord::Migration
  def up
    remove_column :products, :referral_urls
  end

  def down
    add_column :products, :referral_urls, :text
  end
end
