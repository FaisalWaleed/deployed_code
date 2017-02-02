class Browser < ActiveRecord::Base
  attr_accessible :name, :user_agent, :weight
  def self.random_browser
    key_func = ->(i) { i.user_agent }
    weight_func = ->(i) { i.weight }
    pu = Pickup.new all, key_func: key_func, weight_func: weight_func
    pu.pick
  end

  def burnt_count
    Session.last_24.where(browser_id: id).burnt.count
  end
end
