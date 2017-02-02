class AddReferralUrl < ActiveRecord::Migration
  def change
    create_table :referral_urls do |t|
      t.string :url
      t.integer :weight
      t.references :product

      t.timestamps
    end
  end
end
