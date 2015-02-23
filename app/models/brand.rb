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
																 uniqueness: { case_sensitive: false },
	                               format: { with: INSTAGRAM_USERNAME_REGEX }
	
	# Callbacks

	before_validation :append_http
	before_save :remove_trailing_backslash
	before_save :remove_at_sign
	after_save :set_profile_picture

	has_many :sizes, dependent: :destroy

	def self.accessible_attributes
		%w[id name url slug instagram_username]
	end

	def set_profile_picture
		profile = InstagramProfileWorker.perform_async(self.id) if instagram_username
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
