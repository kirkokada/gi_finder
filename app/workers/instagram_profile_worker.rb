class InstagramProfileWorker
	include Sidekiq::Worker
	sidekiq_options retry: true

	def perform(id)
		return if id.nil?
		brand = Brand.find_by_id(id)
		client = Instagram.client(client_id: ENV['INSTAGRAM_CLIENT_ID'])
		profile = client.user_search(brand.instagram_username, count: 1).first
		brand.update_column(:profile_picture, profile['profile_picture'])
	end
end