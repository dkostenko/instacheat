class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :i_id
      t.string :i_name
      t.string :profile_picture

      t.timestamps
    end
  end
end
