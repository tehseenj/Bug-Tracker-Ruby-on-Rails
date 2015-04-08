class CreateBugs < ActiveRecord::Migration
  def change
    create_table :bugs do |t|

      t.string :name
      t.string :description
      t.string :precedense
      t.boolean :done

      t.timestamps
    end
  end
end
