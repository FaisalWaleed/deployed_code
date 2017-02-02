class Product < ActiveRecord::Base
  attr_accessible :keywords, :name, :target_url, :referral_url_list, :session_rate
  after_save :save_referral_url_list
  has_many :referral_urls
  has_many :sessions,
           conditions: proc { ["sessions.updated_at > ?", 24.hours.ago]}

  validates :name, presence: true
  validates :keywords, presence: true
  validates :target_url, presence: true
  validates :session_rate, numericality: {
    only_integer: true, greater_than_or_equal_to: 0
  }


  def random_referral_url
    key_func = ->(i) { i.url }
    weight_func = ->(i) { i.weight }
    pu = Pickup.new referral_urls, key_func: key_func, weight_func: weight_func
    pu.pick
  end

  attr_writer :referral_url_list
  def referral_url_list
    referral_urls.each_with_object('') do |ru, str|
      str << ru.url << ',' << ru.weight.to_s << "\n"
    end
  end


  def save_referral_url_list
    (@referral_url_list || '').split.each do |line|
      url, weight = line.split ','
      referral_urls.where(url: url, weight: weight).first_or_create!
    end
  end

  def session_cache
    @_sessions ||= sessions
  end

  def session_count
    session_cache.all.count { |s| s.failure_reason == 'none' }
  end

  def burnt_count
    session_cache.all.count { |s| s.failure_reason == 'burnt' }
  end

  def average_page
    arr = session_cache.all
          .select { |s| s.failure_reason == 'none' }
          .map(&:page)
    if arr.length > 0
      arr.sum / arr.length
    else
      0
    end
  end

end
