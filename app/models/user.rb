class User < ApplicationRecord
  validates :identity, uniqueness: true
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 5 }
  validates :HalfSize_only
  has_many :muscle_posts

  def HalfSize_only
    if password !~ /\A\w+\z/
      errors.add(:password, " : パスワードは半角英数のみ")
    end
  end
  
end
