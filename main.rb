# Scheme used in numeral/roman conversion
@roman_map = [
	["M",1000],
	["CM",900],
	["D",500],
	["CD",400],
	["C",100],
	["XC",90],
	["L",50],
	["XL",40],
	["X",10],
	["IX",9],
	["V",5],
	["IV",4],
	["I",1]
]

# Hashes to store required values
@space_units_values = {} # e.g: {"glob"=>"I", "prok"=>"V", "pish"=>"X", "tegj"=>"L"}
@metals_values = {} # e.g: {"Silver"=>17.0, "Gold"=>14450.0, "Iron"=>195.5}

# Reads the input file and calls the process_line for each input line
def read_input_file file_name
	File.foreach(file_name) do |line|
    process_line line
	end
end

# Process a line from the input
def process_line line
	case line

	when /^([a-z]+) is ([I|V|X|L|C|D|M])$/
		set_space_unit($1, $2)

	when /^([a-z ]+)([A-Z]\w+) is (\d+) Credits$/
		get_metals_value($1.split, $2, $3)

	when /^how much is ((\w+ )+)\?$/ # Get space_units and convert to numeral
		res = get_numeral_from_space_unit($1.split)
		puts "#{$1}is #{res}"

	when /^how many Credits is ([a-z ]+)([A-Z]\w+) \?$/
		res = (get_numeral_from_space_unit($1.split) * @metals_values[$2]).to_i
		puts "#{$1}#{$2} is #{res} Credits"

	else
		puts "I have no idea what you are talking about"
	end
end

# Sets the space units values
def set_space_unit(key, value)
	@space_units_values[key] = value
end

# Converts a roman string to numeral using the roman_map array
def roman_to_numeral(roman_string)
	sum = 0
	for key, value in @roman_map
		while roman_string.index(key) == 0
			sum += value
			roman_string.slice!(key)
		end
	end
	sum
end

# Gets the numeral value from an array of space units
def get_numeral_from_space_unit(space_units_array)
	# First converts space units array to a roman string
	roman_string = ""
	space_units_array.each do |space_unit|
		roman_string << @space_units_values[space_unit]
	end

	# Then converts the roman string to numeral
  roman_to_numeral(roman_string)
end

# Calculates the metal's value
def get_metals_value(space_units_array, metal, credits)
	numeral = get_numeral_from_space_unit(space_units_array)
	@metals_values[metal] = credits.to_i / numeral.to_f
end

# Calls the method read_input_file passing the input file as a parameter
read_input_file "input.txt"
