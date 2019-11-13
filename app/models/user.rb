class User < ApplicationRecord
  validates :identity, uniqueness: true
  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }

  has_secure_password
  validates :password, presence: true, length: { minimum: 5 }, confirmation: true, on: :create
  # 作成時しかパスワードチェックしない

  attribute :unsubscribed, :boolean, default: -> { false }
  #validates :HalfSize_only
  has_many :muscle_posts
  has_secure_token

  def HalfSize_only
    if :password !~ /\A\w+\z/
      errors.add(:password, " : パスワードは半角英数のみ")
    end
  end

  
end
