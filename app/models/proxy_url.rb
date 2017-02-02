class ProxyUrl < ActiveRecord::Base
  attr_accessible :ip, :port

  validates :ip, presence: true, format: {
    with: /(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/, message: "invalid IP address"
  }
  validates :port, presence: true, numericality: {
    only_integer: true, less_than_or_equal_to: 65535
  }

  scope :active, where(burnt: false)
  belongs_to :proxy

  def self.lru_proxy
    lru = nil
    self.transaction do
      lru = active.order(:updated_at).first
      lru.touch
    end
    lru
  end

  def self.active_count
    active.count
  end

  def to_s
    "#{self.ip}:#{self.port.to_s}"
  end
end
