class CreateQuota < ActiveRecord::Migration
  def change
    create_table :quota do |t|
    	t.integer "user_id"
    	t.integer "allow"
    	t.integer "avail"
    	t.integer "exceed"

      t.timestamps
    end
  end
end
