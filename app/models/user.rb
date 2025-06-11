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

  enum role: { member: 0, admin: 1 } 
  validates :role, presence: true
  validates :name, presence: true

  private 
  
  def self.ransackable_attributes(auth_object = nil)
    %w[name email]
  end
end
