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

	def import(file)
		CSV.foreach(file.path, headers: true) do |row|
			object = find_by_id(row["id"]) || new
			object.attributes = row.to_hash.slice(*accessible_attributes)
			object.save!
		end
	end

	# Attributes to be included in the output CSV file
	
	def accessible_attributes
		raise "Define accessible_attributes method."
	end
end