# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  description :text             not null
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Task < ApplicationRecord  
  validates :name, presence: true
  validates :description, presence: true
end
