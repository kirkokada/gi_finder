class Size < ActiveRecord::Base
	extend CSVImportExport
	validates :name,       presence: true, uniqueness: { scope: :brand }
	validates :brand_id,   presence: true, numericality: { greater_than: 0 }
	validates :max_height, presence: true, 
	                       numericality: { greater_than: 0 }
	validates :min_height, presence: true, 
	                       numericality: { greater_than: 0 }
	validates :max_weight, presence: true, 
	                       numericality: { greater_than: 0 }
	validates :min_weight, presence: true, 
	                       numericality: { greater_than: 0 }

	belongs_to :brand

	delegate :name, :url, :profile_picture, :slug, to: :brand, prefix: true

	# Returns a string indicating the height range in (feet)'(inches)"
	# format.
	def height_range
		max_feet   = max_height.to_i / 12
		max_inches = max_height.to_i % 12
		min_feet   = min_height.to_i / 12
		min_inches = min_height.to_i % 12
		if min_height == 1
			"≤ #{max_feet}'#{max_inches}\""
		elsif max_height > 500
			"≥ #{min_feet}'#{min_inches}\""
		else
			"#{min_feet}'#{min_inches}\" - #{max_feet}'#{max_inches}\""
		end
	end

	# Returns a string indicating the weight range in lbs
	def weight_range
		if min_weight == 1
			"≤ #{max_weight.to_i} lbs"
		elsif max_weight > 500
			"≥ #{min_weight.to_i}"
		else
			"#{min_weight.to_i} - #{max_weight.to_i} lbs"
		end
	end

	# Accepts and options hash, returns an active record association of sizes matching the 
	# height and weight in the options hash. If a matching size for the height and weight
	# doesn't exist, returns a sizes matching only height, then only weight if no matches are found.

	def self.search(options={})
		height = options[:height]
		weight = options[:weight]
		results = match_height(height).match_weight(weight).order('weight_diff')
		if results.empty?
			results = match_height(options[:height])
			if results.empty?
				results = match_weight(options[:weight])
			end
		end
		return results.sort_by_fit(options)
	end

	def self.sort_by_fit(options={})
		height = options[:height]
		weight = options[:weight]
		sql_height = sanitize_sql_for_conditions("(max_height - #{height}) AS height_diff")
		sql_weight = sanitize_sql_for_conditions("(max_weight - #{weight}) AS weight_diff")
		select('sizes.*', sql_weight).order('weight_diff ASC').select('sizes.*', sql_height).order('height_diff ASC')
	end

	def self.match_weight(weight)
		where(':weight >= min_weight AND :weight <= max_weight', weight: weight)
	end

	def self.match_height(height)
		where(':height >= min_height AND :height <= max_height', height: height)
	end

	# For use with the to_csv method of the CSVImportExport module
	# Defines columns to be exported to a CSV
	def self.accessible_attributes
		%w[id name brand_id min_height max_height min_weight max_weight]
	end
end
