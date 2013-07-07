class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  acts_as_voter

  def username
	return nickname if nickname.to_s.length > 0
	return email.slice(0..(email.index('@') - 1)).capitalize if email.to_s.length > 0
	return "Anonymous" 
  end

end
