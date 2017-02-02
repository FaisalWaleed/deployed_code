require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'thread'

class Bot
  @queue = :default
  MAX = 7
  TIMEOUT = 3600

  def self.perform(*args)
    new.perform(*args)
  end

  def create_session(proxy)
    Capybara.reset_sessions!
    options = {
      js_errors: false,
      timeout: 100,
      phantomjs_logger: logger,
      logger: logger
    }
    options[:debug] = true
    options[:phantomjs_options] = ["--proxy=#{proxy.ip}:#{proxy.port}", '--web-security=false']
    # options[:phantomjs_options] << "--debug=true"
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, options)
    end
    Capybara.default_driver = :poltergeist
    Capybara.javascript_driver = :poltergeist
    Capybara.default_wait_time = 100
    Capybara.ignore_hidden_elements = true
    Capybara.run_server = false
    Capybara.app_host = 'http://amazon.com'
    Capybara::Session.new(:poltergeist)
  end

  def setup_timeout
    @queue = Queue.new
    Thread.new do
      sleep TIMEOUT
      @queue << :timeout
    end
  end

  def check_queue(time = 0)
    sleep_time = if time > 1
                   time - 1
                 else
                   time
                 end
    sleep time
    res = @queue.pop(true)
    throw res
  rescue => e
    # noop
  end

  def save_file
    @counter ||= 0
    @counter += 1
    "#{@tag}-#{@counter}.html"
  end

  def perform(id, keyword, proxy = nil, browser = nil, retry_session = true)
    return if ProxyUrl.active_count < 2
    product = Product.where(id: id).first
    return if product.nil?
    @logged = ::Session.create target: product.target_url.strip, keyword: keyword, product_id: id
    @location = 'init'
    proxy ||= ProxyUrl.lru_proxy
    browser ||= Browser.random_browser
    ref = product.random_referral_url

    @logged.proxy_url = proxy
    @logged.browser = Browser.find_by_user_agent(browser)
    @logged.product = product
    @logged.failure_reason = 'currently running'
    @logged.save

    @tag = [id, keyword, proxy.to_s, rand(10_000..99_999)].join('-')
    catch(:done) do
      catch(:timeout) do
        setup_timeout
        tagged_log { |log| log.info "Starting #{product.name} on #{browser} via #{proxy}" }
        @session = create_session proxy
        @session.driver.headers = { 'User-Agent' => browser }
        tagged_log { |log| log.info 'visiting target' }
        @location = 'product page first vist'
        @session.visit product.target_url.strip
        # @session.save_page save_file
        check_queue

        res_url = @session.evaluate_script("document.querySelector('link[rel=canonical]').href")
        res_id = res_url.split('/')[-1]
        res_id = res_url.split('/')[-2] if res_id.length < 10

        if res_id.blank?
          tagged_log { |log| log.error "No resource ID found: #{res_url}" }
          set_failure_reason 'no canonical ASIN'
          return
        end
        check_queue 3
        @session.reset!
        @session.driver.headers = { 'User-Agent' => browser }
        @session.driver.add_header 'Referer', ref, permanent: true
        @location = 'amazon home page'
        @session.visit 'http://' + Addressable::URI.parse(product.target_url).host
        # @session.save_page save_file

        search_for_product keyword, res_id
        check_queue rand(1..MAX)
        # visit_page_features
        add_product_to_cart
      end
    end
  rescue Capybara::Poltergeist::StatusFailError => e
    tagged_log { |log| log.error "network issue: #{e}" }
    set_failure_reason 'network issue'
  rescue Capybara::Poltergeist::TimeoutError => e
    set_failure_reason 'timeout'
  rescue Capybara::Poltergeist::MouseEventFailed,
         Capybara::Poltergeist::ObsoleteNode => e
    tagged_log { |log| log.error "capybara issue: #{e}" }
    set_failure_reason 'capybara issue'
  rescue Capybara::ElementNotFound => e
    tagged_log { |log| log.error '!!!!!!!!!!!!!!!!!' }
    tagged_log { |log| log.error @session.current_url }
    tagged_log { |log| log.error "Browser: #{@logged.browser.id} - #{browser}" }
    tagged_log { |log| log.error @session.save_page if ENV['SAVE_HTML'] }
    tagged_log { |log| log.error e.message }
    tagged_log { |log| log.error '!!!!!!!!!!!!!!!!!' }
    error_cleanup(e, proxy, retry_session)
  rescue => e
    tagged_log { |log| log.error "Error: #{e.message}" }
    tagged_log { |log| log.error e.backtrace[0..10].join("\n") }
    error_cleanup(e, proxy, retry_session)
  ensure
    if @logged
      if @logged.failure_reason == 'currently running'
        @logged.failure_reason = 'none'
      end
      if @logged.failure_reason.length > 255
        set_falure_reason @logged.failure_reason[0...254]
      end
      @logged.save
    end
    @session.driver.quit if @session
  end

  def visit_page_features
    res = @session.all('#imageBlock_feature_div li img')
    if res.present?
      res[rand(0...res.length)].click
      check_queue rand(1..2)
      res = @session.all('.a-button-close')
      if res.present?
        res.first.click
      else
        #@session.save_page
        tagged_log { |log| log.debug "no close button" }
      end
    else
      #@session.save_page
      tagged_log { |log| log.debug "no image block" }
    end
    check_queue rand(1..4)
    reviews = @session.all('#customer-reviews_feature_div .a-icon-row a:nth-child(3)')
    if reviews.present?
      reviews[rand(0..3)].click
      check_queue rand(1..4)
      @session.evaluate_script('window.history.back()')
    else
      tagged_log { |log| log.debug "no reviews" }
      #@session.save_page
    end
  end

  def search_for_product(keyword, target)
    @location = 'initial search'
    input = @session.find('.nav-searchbar input[type=text],#searchForm #searchKeyword,#searchForm #dpSearchKeyword, #nav-search .nav-input[type=text]')
    input.send_keys keyword
    @session.find('.nav-search-submit input,#searchForm button').click

    @logged.page += 1
    retry_capybara = true
    loop do
      @location = "result page #{@logged.page}"
      # @session.save_page save_file
      begin
        tagged_log { |log| log.info "searching for product with keyword '#{keyword}' on #{@session.current_url}" }
        res = @session.all(".s-result-item a[href*=\"#{target}\"]")
        if res.present?
          check_queue rand(1..3)
          link = res.first
          tagged_log { |log| log.info "Clicking on #{link[:href]} for target #{target}" }
          @location = 'going to product page'
          link.click
          @location = 'product page'
          break
        elsif @logged.page > 10
          set_failure_reason 'Too many pages'
          throw :done
        else
          check_queue rand(1..2)
          @session.find('a#pagnNextLink,#search .a-pagination li:last-child a').click
          @logged.page += 1
          retry_capybara = true
        end
      rescue Capybara::ElementNotFound => e
        set_failure_reason 'End of search list'
        throw :done
      rescue Capybara::Poltergeist::MouseEventFailed,
             Capybara::Poltergeist::ObsoleteNode => e
        if retry_capybara
          retry_capybara = false
          @session.visit @session.current_url
          retry
        else
          raise
        end
      end
    end
  end

  def add_product_to_cart
    # @session.save_page save_file
    @location = 'adding to cart'
    tagged_log { |log| log.info 'adding to cart' }
    @session.find_button('add-to-cart-button').click
    @location = 'done'
  rescue Capybara::ElementNotFound => e
    url = @session.current_url[0..100]
    set_failure_reason "unable to find add to cart button on #{url}"
    throw :done
  end

  def error_cleanup(e, proxy, retry_session)
    html = @session && @session.html rescue ''
    if (html || '').match(/Sorry, we just need to make sure you're not a robot/)
      set_failure_reason 'burnt'
      proxy.burnt = true
      proxy.save
    else
      set_failure_reason 'timeout'
      fail e if retry_session
    end
  end

  def logger
    @logger ||= ActiveSupport::TaggedLogging.new(Logger.new(Rails.root.join('log', 'bot.log')))
  end

  def tagged_log
    logger.tagged(Time.now.to_s, @tag) { |l| yield l }
  end

  def set_failure_reason(reason)
    return unless @logged
    @logged.location = @location
    @logged.failure_reason = reason
  end
end
