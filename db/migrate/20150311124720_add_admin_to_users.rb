class AddAdminToUsers < ActiveRecord::Migration
  def change
    # nil by default, which is false, but this just makes it more clear.
    add_column :users, :admin, :boolean, default: false
  end
end
