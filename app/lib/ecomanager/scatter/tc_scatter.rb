require 'test/unit'
require 'graph.rb'
require 'scatter.rb'

class TC_ScatterTest < Test::Unit::TestCase
	# Can add graphs to a scatter diagram. For scatter diagram explanation, see RGraph scatter diagram.
	# The diagram is represented as a JavaScript matrix, and can be used directly in JavaScript code. The purpose is to be used as data for a HTML5 RGraph scatter diagram.
	
	def test_one_graph_scatter()
		scatter = Scatter.new()
		
		graph = Graph.new()
		graph.put(10, -2500)
		graph.put(10, 2500)
		scatter.add(graph)
	
		js_expected = "[[[10, -2500], [10, 2500]]]"
		js = scatter.to_s()
		
		assert_equal(js_expected, js)
	end
	

	def test_two_graph_scatter()
		scatter = Scatter.new()
		
		graph = Graph.new()
		graph.put(10, -2500)
		graph.put(10, 2500)
		scatter.add(graph)
		
		graph = Graph.new()
		graph.put(1, 2000)
		graph.put(1, 1500)
		graph.put(4, 600)
		graph.put(4, -600)
		graph.put(7, -1400)
		graph.put(10, -1000)
		scatter.add(graph)
		
		js_expected = "[[[10, -2500], [10, 2500]], [[1, 2000], [1, 1500], [4, 600], [4, -600], [7, -1400], [10, -1000]]]"
		js = scatter.to_s()
		
		assert_equal(js_expected, js)
	end
	
	# TODO: Test nicely formatted javascript.

end