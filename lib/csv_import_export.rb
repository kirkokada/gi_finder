module CSVImportExport
	# Exports data to csv file

	def to_csv(options={})
		CSV.generate(options) do |csv|
			csv << accessible_attributes
			all.each do |brand|
				csv << brand.attributes.values_at(*accessible_attributes)
			end
		end
	end

	# Imports model data from a CSV file
	# Accepts options hash to skip records without 
	# the specified key-value pair (e.g., brand_id: 1)

	def import(file, opts={})
		CSV.foreach(file.path, headers: true) do |row|
			catch :skip_row do
				unless opts[:limit_to].nil?
					opts[:limit_to].each_pair do |key, value|
						throw :skip_row if row.to_hash[key.to_s] != value.to_s
					end
				end
				args = opts[:find_by] || { id: row["id"] }
				object = find_by(args) || new
				object.attributes = row.to_hash.slice(*accessible_attributes)
				object.save!
			end
		end
	end

	# Attributes to be included in the output CSV file
	
	def accessible_attributes
		raise "Define accessible_attributes method."
	end
end