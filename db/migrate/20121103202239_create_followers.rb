class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.integer :i_id
      t.boolean :followto, :default => false
      t.boolean :followme, :default => false

      t.timestamps
    end
  end
end
