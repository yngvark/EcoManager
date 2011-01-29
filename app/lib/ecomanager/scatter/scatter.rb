require 'graph'
require 'chart'

class Scatter < Chart
	
	private
	
	def graphs_to_string()
		graph_separator = ", "
		string = ""

		@graphs.each do |graph|
			string += graph.to_s() + ", "
		end
		
		# Remove the last graph separator from the string.
		string = string[0, string.length - graph_separator.length]
		
		return string
	end

end