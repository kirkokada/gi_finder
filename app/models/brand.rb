class Brand < ActiveRecord::Base
	extend FriendlyId
	extend CSVImportExport

	friendly_id :name, use: :slugged

	# Regular expressions

	VALID_URL_REGEX = /\Ahttps?:\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}\/*\z/ix
	INSTAGRAM_USERNAME_REGEX = /\A@{0,1}[\w]+\z/i

	# Validations

	validates :url,     presence: true, 
	                    format: { with: VALID_URL_REGEX } 
	validates :instagram_username, allow_nil: true,
																 allow_blank: true,
																 uniqueness: { case_sensitive: false },
	                               format: { with: INSTAGRAM_USERNAME_REGEX }
	
	# Callbacks

	before_validation :append_http
	before_save :remove_trailing_backslash
	before_save :remove_at_sign
	after_save :set_profile_picture

	has_many :sizes, dependent: :destroy

	def self.accessible_attributes
		%w[id name url slug instagram_username profile_picture]
	end

	def set_profile_picture
		return if instagram_username.nil? || instagram_username.blank? || !instagram_username_changed?
		update_column(:profile_picture, instagram_profile['profile_picture'])
	end

	def instagram_profile
		client = Instagram.client(client_id: ENV['INSTAGRAM_CLIENT_ID'])
		profile = client.user_search(instagram_username, count: 1).first
		return profile
	end

	private
		# Appends 'http://' to the url if not present
		def append_http
			return if url.nil?
			self.url = "http://#{self.url}" unless self.url[/\Ahttps?:\/\//]
		end

		def remove_trailing_backslash
			url.chop if url.last == "/"
		end

		def remove_at_sign
			instagram_username.slice!(0) if instagram_username && instagram_username.first == "@"
		end
end
