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
		return if !has_ig_username? || !instagram_username_changed?
		update_column(:profile_picture, ig_profile['profile_picture'])
	end

	def ig_profile
		client = ig_client
		profile = client.user_search(instagram_username, count: 1).first
		return profile
	end

	def ig_client
		Instagram.client(client_id: ENV['INSTAGRAM_CLIENT_ID'])
	end

	# Returns a Hashie:Mash of recent Instagram media tagged with
	# either the instagram username or the closest tag search result for
	# the brand name
	def ig_media
		if has_ig_username?
			tag = instagram_username
		else
			tag = find_ig_tag(name)
			return [] if tag.nil?
		end
		media = ig_client.tag_recent_media(tag)
	end

	# Returns a string representing the tag with the most media for
	# the given string. May be problematic if the string is a common word.
	def find_ig_tag(string)
		tags = ig_client.tag_search(usernameify(string))
		return nil if tags.empty?
		# Sort the tags by media count in descending order
		tags.sort { |t1, t2| t2.media_count <=> t1.media_count }
		tag = tags.first.name
		return tag
	end

	def has_ig_username?
		instagram_username && !instagram_username.blank?
	end

	# Removes non-word characters from a string

	def usernameify(username)
		username.gsub(/[\W]+/, "").downcase
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
