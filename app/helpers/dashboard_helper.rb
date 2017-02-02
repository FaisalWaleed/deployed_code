module DashboardHelper
  def percentage(num, den)
    val = (num.to_f/den).round(4) * 100
    val.nan? ? "0%" : "#{val}%"
  end
end
