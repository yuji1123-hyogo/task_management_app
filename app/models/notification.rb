# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  message         :string
#  notifiable_type :string           not null
#  read            :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notifiable_id   :integer          not null
#  user_id         :integer          not null
#
# Indexes
#
#  index_notifications_on_notifiable                         (notifiable_type,notifiable_id)
#  index_notifications_on_notifiable_type_and_notifiable_id  (notifiable_type,notifiable_id)
#  index_notifications_on_user_id                            (user_id)
#  index_notifications_on_user_id_and_read                   (user_id,read)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read:false) }
  scope :recent, -> { order(created_at: :desc) }
end
