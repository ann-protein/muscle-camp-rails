class User < ApplicationRecord
  validates :identity, uniqueness: true
  has_many :muscle_posts
end
