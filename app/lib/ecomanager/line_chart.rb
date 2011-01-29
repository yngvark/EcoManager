require 'graph'
require 'chart'

class LineChart < Chart

  private

	def graphs_to_string()
		graph_separator = ", "
		string = ""

		@graphs.each do |graph|
      graph_values_floats = graph_values_to_float(graph)
      string += "[" + graph_values_floats.join(", ") + "], "
		end

		# Remove the last graph separator from the string.
		string = string[0, string.length - graph_separator.length]

    return string
	end

  private

  def graph_values_to_float(graph)
    graph_values = graph.values
    graph_values_floats = []
    for i in (0..graph.values.length - 1)
      graph_values_floats.push(graph_values[i].to_f)
    end

    return graph_values_floats
  end

end