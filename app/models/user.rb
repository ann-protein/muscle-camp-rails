class User < ApplicationRecord
  validates :identity, uniqueness: true
end
