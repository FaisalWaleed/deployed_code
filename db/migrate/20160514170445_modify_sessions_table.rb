class ModifySessionsTable < ActiveRecord::Migration
  def up
    add_column :sessions, :product_id, :integer
    add_column :sessions, :failure_reason, :string
    Session.where(burnt: true).update_all(failure_reason: 'burnt')
    Session.where(timeout: true).update_all(failure_reason: 'timeout')
    remove_column :sessions, :timeout
    remove_column :sessions, :burnt
  end
end

class Session < ActiveRecord::Base; end
