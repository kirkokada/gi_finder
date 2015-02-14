class Size < ActiveRecord::Base
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

	def height_range
		max_feet   = max_height.to_i / 12
		max_inches = max_height.to_i % 12
		min_feet   = min_height.to_i / 12
		min_inches = min_height.to_i % 12
		"#{min_feet}'#{min_inches}\" - #{max_feet}'#{max_inches}\""
	end

	def weight_range
		if min_weight == 1
			"≤ #{max_weight.to_i} lbs"
		else
			"#{min_weight.to_i} - #{max_weight.to_i} lbs"
		end
	end
end
