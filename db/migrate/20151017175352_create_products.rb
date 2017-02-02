class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :target_url
      t.text :referral_urls
      t.text :keywords

      t.timestamps
    end
  end
end
