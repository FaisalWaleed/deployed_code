class ReferralUrl < ActiveRecord::Base
  attr_accessible :url, :weight, :product_id

  validates :url, presence: true
  validates :weight, presence: true, numericality: {
    only_integer: true, greater_than: 0, less_than_or_equal_to: 100
  }

  belongs_to :product
end
