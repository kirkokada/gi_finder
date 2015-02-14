class Size < ActiveRecord::Base
	extend CSVImportExport
	validates :name,       presence: true, uniqueness: { scope: :brand }
	validates :brand_id,   presence: true
	validates :max_height, presence: true, 
	                       numericality: { greater_than: 0 }
	validates :min_height, presence: true, 
	                       numericality: { greater_than: 0 }
	validates :max_weight, presence: true, 
	                       numericality: { greater_than: 0 }
	validates :min_weight, presence: true, 
	                       numericality: { greater_than: 0 }

	belongs_to :brand

	# Returns a string indicating the height range in (feet)'(inches)"
	# format.
	def height_range
		max_feet   = max_height.to_i / 12
		max_inches = max_height.to_i % 12
		min_feet   = min_height.to_i / 12
		min_inches = min_height.to_i % 12
		"#{min_feet}'#{min_inches}\" - #{max_feet}'#{max_inches}\""
	end

	# Returns a string indicating the weight range in lbs
	def weight_range
		if min_weight == 1
			"≤ #{max_weight.to_i} lbs"
		else
			"#{min_weight.to_i} - #{max_weight.to_i} lbs"
		end
	end

	# For use with the to_csv method of the CSVImportExport module
	# Defines columns to be exported to a CSV
	def self.accessible_attributes
		%w[id name brand_id min_height max_height min_weight max_weight]
	end
end
