class Proxy < ActiveRecord::Base
  attr_accessible :name, :provider_url, :proxy_url_list
  after_save :save_proxy_url_list

  has_many :proxy_urls

  validates :name, presence: true
  validates :proxy_urls, associated: true

  def self.random_proxy
    proxy = self.offset(rand(self.count)).first

    offset = rand proxy.proxy_urls.active.count
    proxy.proxy_urls.active.offset(offset).first
  end

  def proxy_url_list
    proxy_urls.each_with_object('') do |prx, str|
      str << prx.to_s << "\n"
    end
  end

  def proxy_url_list=(val)
    @proxy_url_list = val
  end

  def save_proxy_url_list
    bnt = proxy_urls.where(burnt: true).all.each_with_object({}) do |prx, hsh| 
      hsh[prx.to_s] = prx.burnt
    end
    proxy_urls.destroy_all
    (@proxy_url_list || '').split.each do |line|
      ip, port = line.split ':'
      pr = create_proxy ip, port
      if bnt[pr.to_s]
        pr.burnt = true
        pr.save!
      end
    end
  end

  def create_proxy(ip, port)
    proxy_urls.where(ip: ip, port: port).first_or_create!
  end
end

