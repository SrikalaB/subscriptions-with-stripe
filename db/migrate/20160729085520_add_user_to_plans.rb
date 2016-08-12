class AddUserToPlans < ActiveRecord::Migration
  def change
    add_reference :plans, :user, index: true, foreign_key: true
    add_foreign_key :plans, :users
  end
end
