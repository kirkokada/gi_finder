class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Virtual attribute for authenticating by either username or email
    attr_accessor :login

  # Constants

  VALID_USERNAME_REGEX = /\A[\w]+\z/

  # Validations

  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       format: { with: VALID_USERNAME_REGEX }

  validates :height, numericality: { greater_than: 0 }

  validates :weight, numericality: { greater_than: 0 }

  # Callbacks

  before_save :downcase_username
  before_save :downcase_email
  before_save :height_and_weight_to_float

  # Overwrites Devise's default find_for_database_authentication method to allow
  # sign in with either email or username

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", 
      	                            { :value => login.downcase }]).first
    else
      where(conditions.to_h).first
    end
  end

  private

  	def downcase_username
  		self.username.downcase!
  	end

  	def downcase_email
  		self.email.downcase!
  	end

  	def height_and_weight_to_float
  		height = height.to_f unless self.height.is_a?(Float)
  		weight = weight.to_f unless self.weight.is_a?(Float)
  	end
end
