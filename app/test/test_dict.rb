my_filter = {
      "OSLO BOLIG OG S" => 1,
      "bunnpris" => 2,
      "STORÅS" => 3
    }

description = "Nettgiro til: OSLO BOLIG OG S Betalt: 30.08.10"

my_filter.each do |filter_string, account|
	puts filter_string.downcase
	puts 
  if description.downcase.include?(filter_string.downcase)
	puts "YEAH"
  end
end

