require 'graph'

class Chart
  
  def initialize()
		@graphs = []
	end

	def add(graph)
		@graphs.push(graph)
	end

	def to_s()
		result = "["
		result += graphs_to_string()
		result += "]"
	end

end