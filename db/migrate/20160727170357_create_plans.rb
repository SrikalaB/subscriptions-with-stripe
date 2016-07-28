class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :plan_name
      t.string :interval
      t.float  :cost

      t.timestamps null: false
    end
  end
end
