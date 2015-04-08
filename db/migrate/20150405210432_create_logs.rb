class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :a_log

      t.timestamps
    end
  end
end
