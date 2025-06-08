class Tag < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags
end
