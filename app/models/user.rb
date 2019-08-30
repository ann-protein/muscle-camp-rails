class User < ApplicationRecord
  validates :identity, uniqueness: true
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 5 }
  has_many :muscle_posts
end
