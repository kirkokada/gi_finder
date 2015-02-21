class SizeImport
	include ActiveModel::Model

	attr_accessor :file, :import_options

	def save
		if imported_sizes.map(&:valid?).all?
			imported_sizes.each(&:save!)
			true
		else
			imported_sizes.each_with_index do |size, index|
				size.errors.full_messages.each do |message|
					errors.add :base, "Row #{index + 2}: message"
				end
			end
			false
		end
	end

	def imported_sizes
		@imported_sizes ||= load_imported_sizes(import_options)
	end

	def load_imported_sizes(options={})
		confirm_file
		sizes = []
		CSV.foreach(file.path, headers: true) do |row|
			row = row.to_hash
			raise row.to_s if row['brand_slug'].nil?
			unless row['brand_slug'].nil?
				brand = find_brand(row['brand_slug'])
				size = brand.sizes.build
			else
				size = Size.find_by_id(row['id']) || Size.new
			end	
			size.attributes = row.slice(*Size.accessible_attributes)
			sizes << size
		end
		sizes
	end

	def find_brand(brand_slug)
		Brand.friendly.find(brand_slug)
	end

	def confirm_file
		unless File.extname(file.original_filename) == ".csv"
			raise "Unaccepted file type: #{file.original_filename}" 
		end
	end
end