require 'capybara/poltergeist'

proxy ||= ProxyUrl.lru_proxy
browser ||= Browser.random_browser
Capybara.reset_sessions!
options = {
  js_errors: false,
  timeout: 300,
  phantomjs_logger: logger,
  logger: logger
}
options[:debug] = true if ENV['DEBUG']
options[:phantomjs_options] = ["--proxy=#{proxy.ip}:#{proxy.port}", '--web-security=false']
options[:phantomjs_options] << "--debug=true" if ENV['DEBUG']
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, options)
end
Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 60
Capybara.ignore_hidden_elements = true
Capybara.run_server = false
Capybara.app_host = 'http://amazon.com'

@session = Capybara::Session.new(:poltergeist)
ref = 'https://twitter.com/IulianDaniel1/status/665100122255171584'
@session.driver.headers = { 'Referer' => ref, 'User-Agent' => browser }
url = 'http://www.amazon.com/dp/B015S1CWGU'
@session.visit url
res_id = "B015S1CWGU"
keyword = "amclithia sup paddle"
sleep 2

input = @session.find(".nav-searchbar input[type=text],#searchForm #searchKeyword").native
input.send_keys keyword
@session.find(".nav-search-submit input,#searchForm button").click
@session.all("a[href*=#{res_id}]").first.click

@session.find('a#pagnNextLink').click
@session.find_button('add-to-cart-button').click

@session.save_screenshot
