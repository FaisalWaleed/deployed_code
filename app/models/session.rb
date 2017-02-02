class Session < ActiveRecord::Base
  belongs_to :proxy_url
  belongs_to :browser
  belongs_to :product
  attr_accessible :burnt, :keyword, :target, :timeout, :proxy_url, :browser

  validates :keyword, presence: true
  validates :target, presence: true

  scope :burnt, where(failure_reason: 'burnt')
  scope :timed_out, where(failure_reason: 'timeout')
  scope :completed, where(failure_reason: 'none')
  scope :last_24, ->() { where('updated_at > ?', 24.hours.ago) }

  def self.clean_up_old_sessions
    where('updated_at < ?', 1.week.ago).delete_all
  end

  def referral_url
    product.try(:referral_urls).try(:first).try(:url)
  end
end
