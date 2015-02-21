class Brand < ActiveRecord::Base
	extend FriendlyId
	extend CSVImportExport

	friendly_id :name, use: :slugged

	VALID_URL_REGEX = /\Ahttps?:\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}\/*\z/ix

	validates :url,     presence: true, 
	                    format: { with: VALID_URL_REGEX } 
	                    
	before_validation :append_http
	before_save :remove_trailing_backslash

	has_many :sizes, dependent: :destroy

	def self.accessible_attributes
		%w[id name url slug]
	end

	private
		# Appends 'http://' to the url if not present
		def append_http
			return if url.nil?
			self.url = "http://#{self.url}" unless self.url[/\Ahttps?:\/\//]
		end

		def remove_trailing_backslash
			url.chop if url .last == "/"
		end
end
