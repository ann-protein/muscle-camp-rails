class BodyPart < ApplicationRecord
  validates :name, uniqueness: true
  has_many :tag_maps
  has_many :muscle_posts, through: :tag_maps
end
