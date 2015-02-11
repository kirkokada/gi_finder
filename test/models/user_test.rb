require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
  	@user = User.new(username: "username", 
  		               email: "example@email.com",
  		               height: '70',
  		               weight: '150', 
  		               password: "password",
  		               password_confirmation: "password")
  end

  test "should be valid" do
  	assert @user.valid?
  end

  test "username should be present" do
  	@user.username = nil
  	assert_not @user.valid?
  end

  test "username should be unique" do
  	dup = @user.dup
  	dup.username.upcase!
  	@user.save
  	assert_not dup.valid?
  end

  test "username should contain only word characters" do
  	invalid_usernames = %w[usern@me user\ name u$er-name]
  	invalid_usernames.each do |name|
  		@user.username = name
  		assert_not @user.valid?
  	end
  end

  test "usernames should be downcased before saving" do
  	upcased = "USERNAME"
  	@user.username = upcased
  	@user.save
  	assert_equal upcased.downcase, @user.reload.username
  end

  test "email should be downcased before saving" do
  	upcased_email = "EMAIL@EMAIL.COM"
  	@user.email = upcased_email
  	@user.save
  	assert_equal upcased_email.downcase, @user.reload.email
  end
end
