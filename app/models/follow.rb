# == Schema Information
#
# Table name: follows
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :integer          not null
#  follower_id :integer          not null
#
# Indexes
#
#  index_follows_on_followed_id                  (followed_id)
#  index_follows_on_follower_id                  (follower_id)
#  index_follows_on_follower_id_and_followed_id  (follower_id,followed_id) UNIQUE
#
# Foreign Keys
#
#  followed_id  (followed_id => users.id)
#  follower_id  (follower_id => users.id)
#
class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :follower_id, uniqueness: { scope: :follwed_id }
  validate :cannot_follow_self

  after_create :create_notification

  private

  def connnot_follow_self
    errors.add(:follower, "自分自身を")
  end

  def create_notification
    notifications.create!(
      user: followed,
      message: "#{follower.name}があなたをフォローしました"
    )
  end
end
