class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
       t.integer :user_id
       t.integer :event_id
       t.string :state
      t.timestamps
    end
  end
end
