module ProxiesHelper
  def proxy_class
    case @proxy_count
    when 0..4
      'alert-danger'
    when 5..10
      'alert-warning'
    when 10..50
      'alert-info'
    else
      'alert-success'
    end
  end
end
