sessions = Session.where('updated_at > ?', 1.week.ago).burnt.all

class ProductCounter
  attr_reader :product, :count
  def initialize(session)
    @product = session.product
    @count = 0
  end

  def add
    @count += 1
    self
  end

  def self.headers
    "Name,ID,Count,Session Rate"
  end

  def report
    "#{product.name rescue 'deleted'},#{product.id rescue 'deleted'},#{count},#{product.session_rate rescue 'n/a'}"
  end
end

class BrowserCounter
  attr_reader :browser, :count
  def initialize(session)
    @browser = session.browser
    @count = 0
  end

  def add
    @count += 1
    self
  end

  def self.headers
    "Name,ID,Count,Weight"
  end

  def report
    "#{browser.name rescue 'deleted'},#{browser.id rescue 'deleted'},#{count},#{browser.weight rescue 'n/a'}"
  end
end

class Collector
  def initialize
    @phsh = Hash.new
    @bhsh = Hash.new
  end

  def collect(sessions)
    sessions.each_with_object(self) do |el, obj|
      obj.add(el)
    end
  end

  def add(item)
    @phsh[item.product_id] ||= ProductCounter.new(item)
    @phsh[item.product_id].add
    @bhsh[item.browser_id] ||= BrowserCounter.new(item)
    @bhsh[item.browser_id].add
  end

  def browser_report
    output @bhsh.values
  end

  def product_report
    output @phsh.values
  end

  def output(values)
    values.sort_by(&:count).each {|c| puts c.report }
  end

  def report
    puts "Product"
    puts "=" * 50
    puts ProductCounter.headers
    product_report
    puts "Browser"
    puts "=" * 50
    puts BrowserCounter.headers
    browser_report
  end
end

c = Collector.new
c.collect sessions
c.report