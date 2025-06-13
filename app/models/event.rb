# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  content    :text
#  end_at     :datetime
#  name       :string
#  place      :string
#  start_at   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :integer
#
# Indexes
#
#  index_events_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  owner_id  (owner_id => users.id)
#
class Event < ApplicationRecord
  has_many   :tickets, dependent: :destroy
  has_many :participants, through: :tickets, source: :user
  
  belongs_to :owner, class_name: 'User'
  validates  :name, length: { maximum: 50 }, presence: true
  validates  :place, length: { maximum: 100 }, presence: true
  validates  :content, length: { maximum: 2000 }, presence: true
  validates  :start_at, presence: true
  validates  :end_at, presence: true
  validate  :start_at_should_be_before_end_at

  scope :by_participation_status, ->(user, status) {
    case status
    when 'participated'
      participated_by_user(user)
    when 'not_participated'
      not_participated_by_user(user)
    else
      all
    end
  }


  # 効率的なサブクエリを使った参加済みイベント
  scope :participated_by_user, ->(user) {
    joins(:participants).where(participants: { id: user.id})
  }

  # 未参加イベント（効率的なサブクエリ版）
  scope :not_participated_by_user, ->(user) {
    where.not(id: user.participated_events.pluck(:id))
  }

  private

  def start_at_should_be_before_end_at

    return unless start_at && end_at 

    if start_at >= end_at 
      errors.add(:start_at, "は終了時間よりも前に設定してください")
    end
  end

  # Ransack で検索可能にしたいカラムを明示
  def self.ransackable_attributes(auth_object = nil)
    %w[name content place start_at end_at owner_id owner_id created_at]
  end

  # 関連モデル(owner)を検索条件に使う場合はこれも必要
  def self.ransackable_associations(auth_object = nil)
    %w[owner]
  end

  # Ransackで使用可能にする
  def self.ransackable_scopes(auth_object = nil)
    %w[by_participation_status]
  end

end
