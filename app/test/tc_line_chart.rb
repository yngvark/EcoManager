require 'test/unit'
require 'graph.rb'
require 'chart/line_chart.rb'

class TC_LineTest < Test::Unit::TestCase
	# Can add graphs to a scatter diagram. For scatter diagram explanation, see RGraph scatter diagram.
	# The diagram is represented as a JavaScript matrix, and can be used directly in JavaScript code. The purpose is to be used as data for a HTML5 RGraph scatter diagram.
	
	def test_javascript_for_one_graphs()
		chart = LineChart.new()
		
		graph = Graph.new()
		graph.put(0, 0)
		graph.put(1, 2000)
    graph.put(2, 8000)
		chart.add(graph)
	
		js_expected = "[[0.0, 2000.0, 8000.0]]"
		js = chart.to_s()
		
		assert_equal(js_expected, js)
	end
	

	def test_two_graph_scatter()
		chart = LineChart.new()

		g = Graph.new()
		g.put(0, 0)
		g.put(1, 2000)
    g.put(2, 8000)
		chart.add(g)

    g2 = Graph.new()
		g2.put(0, 1000)
		g2.put(1, -3000)
    g2.put(2, -2000)
		chart.add(g2)

    js_expected = "[[0.0, 2000.0, 8000.0], [1000.0, -3000.0, -2000.0]]"
		js = chart.to_s()

		assert_equal(js_expected, js)
	end
	
	# TODO: Test nicely formatted javascript.

end