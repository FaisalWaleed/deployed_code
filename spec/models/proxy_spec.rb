require 'spec_helper'

RSpec.describe Proxy do
  let(:list) do
    <<-EOL.strip_heredoc
    50.31.9.27:8800
    173.234.232.140:8800
    173.234.232.151:8800
    173.234.181.175:8800
    173.234.181.208:8800
    50.2.15.223:8800
    50.31.9.76:8800
    173.234.181.24:8800
    173.234.181.188:8800
    50.2.15.76:8800
    EOL
  end
  it 'requires a name' do
    p = Proxy.new
    expect(p).not_to be_valid
  end

  it 'saves the proxy list' do
    p = Proxy.new name: 'SquidProxies', proxy_url_list: list
    p.save!
    p.reload
    expect(p.proxy_urls).not_to be_empty
  end
end
