class DashboardController < ApplicationController
  def index
    @sessions = Session.select('count(*) as count, page, failure_reason').last_24.group(:page, :failure_reason)
    @session_count = @sessions.map(&:count).sum
    @burned_count = session_count('burnt')
    @timed_out_count = session_count('timeout')
    @complete_session_count = session_count('none')
  end

  def session_count(failure_reason)
    @sessions.select { |s| s.failure_reason == failure_reason }.map(&:count).sum
  end
end
