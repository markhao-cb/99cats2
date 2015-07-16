# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  user_name       :string(255)      not null
#  password_digest :string(255)      not null
#  session_token   :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class User < ActiveRecord::Base
  validates :user_name, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 , allow_nil: true}

  attr_reader :password

  has_many(
    :cats,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Cat
  )

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def self.find_by_credentials(user_name,password)
    user = User.find_by(user_name: user_name)
    if user && user.is_password?(password)
      user
    end
  end


  private

  def user_params
      params.require(:user).permit(:user_name,:password)
  end
end
