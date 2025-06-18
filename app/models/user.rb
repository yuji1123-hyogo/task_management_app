# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("member"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :created_events, class_name: 'Event', foreign_key: 'owner_id', dependent: :destroy
  has_many :tickets, dependent: :destroy
  has_many :participated_events, through: :tickets, source: :event
  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :post
  has_many :articles, dependent: :destroy
  has_many :notifications, dependent: :destroy





  enum role: { member: 0, admin: 1 } 
  validates :role, presence: true
  validates :name, presence: true

  def favorite_post?(post)
    favorites.exists?(post: post)
  end
  
  def toggle_favorite(post)
    favorite = favorites.find_by(post: post)
    if favorite
      favorite.destroy
      false
    else
      favorites.create!(post: post)
      true
    end
  end
  
  private 
  
  def self.ransackable_attributes(auth_object = nil)
    %w[name email]
  end
end
