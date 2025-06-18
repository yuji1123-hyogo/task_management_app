class CreateLoans < ActiveRecord::Migration[7.1]
  def change
    create_table :loans do |t|
      t.references :book, null: false, foreign_key: true
      t.references :member, null: false, foreign_key: true
      t.datetime :borrowed_at, null: false
      t.datetime :returned_at

      t.timestamps
    end
    add_index :loans, [:book_id, :member_id, :returned_at], 
              name: 'index_loans_on_book_member_returned'
  end
end
