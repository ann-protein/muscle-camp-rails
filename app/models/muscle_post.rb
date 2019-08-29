class MusclePost < ApplicationRecord
  has_many :tag_maps
  belongs_to :user
end
