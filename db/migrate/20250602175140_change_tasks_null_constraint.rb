class ChangeTasksNullConstraint < ActiveRecord::Migration[7.1]
  def change
    change_column_null :tasks, :name, false
    change_column_null :tasks, :description, false
  end
end
