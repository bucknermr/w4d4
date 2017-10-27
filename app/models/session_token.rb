class SessionToken < ApplicationRecord
  validates :user_id, :session_token, presence: true

  belongs_to :user
end
