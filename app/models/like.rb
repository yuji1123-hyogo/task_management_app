# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_likes_on_article_id  (article_id)
#  index_likes_on_user_id     (user_id)
#
# Foreign Keys
#
#  article_id  (article_id => articles.id)
#  user_id     (user_id => users.id)
#
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :article

  has_many :notifications, as: :notifiable, dependent: :destroy
  validates :user_id, uniqueness: { scope: :article_id }


  after_create :create_notification

  private

  def create_notification
    return if user == article.user

    notifications.create!(
      user: article.user,
      message: "#{user.name}があなたの記事をいいねしました"
    )
  end
end
