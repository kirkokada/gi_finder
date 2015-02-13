class Brand < ActiveRecord::Base
	extend FriendlyId
	extend CSVImportExport
	friendly_id :name, use: :slugged

	VALID_URL_REGEX = /\Ahttps?:\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}$\z/ix

	validates :url,     presence: true, 
	                    format: { with: VALID_URL_REGEX } 
	                    
	before_validation :append_http

	def self.accessible_attributes
		%w[id name url]
	end

	private
		# Appends 'http://' to the url if not present
		def append_http
			return if url.nil?
			self.url = "http://#{self.url}" unless self.url[/\Ahttps?:\/\//]
		end
end