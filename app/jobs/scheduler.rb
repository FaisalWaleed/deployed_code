class Scheduler
  @queue = :default
  MINUTES_IN_HOUR = 60
  HOURS_IN_DAY = 24

  def self.perform
    new.perform
  end

  def perform
    if ProxyUrl.active_count < 2
      return
    end
    Product.all.each { |p| schedule p }
  end

  def schedule(product)
    rate = product.session_rate
    return if rate.zero?
    Resque.dequeue Bot, product.id, product.keywords
    per_hour = rate / HOURS_IN_DAY
    count = MINUTES_IN_HOUR.to_f / per_hour
    per_hour.times do |i|
      time = (count * i).minutes
      Resque.enqueue_in time, Bot, product.id, product.keywords
    end
  end
end
