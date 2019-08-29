class BodyPart < ApplicationRecord
  validates :name, uniqueness: true
  has_many :tag_maps
end
