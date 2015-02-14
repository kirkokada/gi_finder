FactoryGirl.define do
  factory :user do
    username "user"
		email "user@email.com"
		height 70
		weight 150
		password "password"
		password_confirmation "password"
  end
end
