class MusclePost < ApplicationRecord
  has_many :tag_maps, dependent: :destroy
  has_many :body_parts, through: :tag_maps
  belongs_to :user
  validates :body, :title, presence: true
end
