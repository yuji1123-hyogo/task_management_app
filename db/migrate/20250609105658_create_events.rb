class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.integer :owner_id, index: true
      t.string :name
      t.string :place
      t.datetime :start_at
      t.datetime :end_at
      t.text :content

      t.timestamps
    end
     add_foreign_key :events, :users, column: :owner_id
  end
end
