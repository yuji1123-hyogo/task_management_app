class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :notifiable, polymorphic: true , null: false
      t.string :message
      t.boolean :read, default: false

      t.timestamps
    end
    
    add_index :notifications, [:user_id, :read]
    add_index :notifications, [:notifiable_type, :notifiable_id]
  end
end
