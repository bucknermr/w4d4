class User < ApplicationRecord
  attr_reader :password

  validates :username, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }

  after_initialize :ensure_session_token

  has_many :cat_rental_requests

  has_many :session_tokens

  has_many :cats,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: 'Cat'

  def reset_session_token!
    # current_user.session_tokens.find_by(session_token: session[:session])
    # session[:session_token]

    self.session_token = SecureRandom.urlsafe_base64(16)
    self.save
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    auth_hash = BCrypt::Password.new(self.password_digest)
    auth_hash.is_password?(password)
  end

  def self.find_by_credentials(username, pw)
    user = User.find_by(username: username)
    return nil unless user
    user.is_password?(pw) ? user : nil
  end
end
