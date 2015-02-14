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

	def import(file, options={})
		CSV.foreach(file.path, headers: true) do |row|
			catch :skip_row do
				unless options.empty?
					options.each_pair do |key, value|
						throw :skip_row if row.to_hash[key.to_s] != value.to_s
					end
				end
				object = find_by_id(row["id"]) || new
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