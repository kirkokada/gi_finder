# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Default admin user

puts "Seeding Users..."
admin = User.new(username: "admin",
						email: "admin@email.com",
	          password: "password",
	          password_confirmation: "password",
	          height: 70,
	          weight: 150,
	          admin: true)
admin.save!
puts "Compete!"