class Ticket < ApplicationRecord
  validates :event_id, uniqueness: { scpoe: :user_id  }
  belongs_to :user, optional: true
  belongs_to :event

  validates :comment, length: { maximum: 30 }, allow_blank: true
end
