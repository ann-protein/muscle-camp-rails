class BodyPart < ApplicationRecord
  validates :name, uniqueness: true
end
