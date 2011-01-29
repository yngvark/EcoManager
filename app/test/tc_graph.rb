require 'test/unit'
require 'graph.rb'

#Overordnet:
#OK - Vise et diagram med grafer, slik som i Excel.
#- Lage graf i scatter/diagram basert på CSV-input, som viser saldo etter hver transaksjon.
#- La CSV-input hentes fra fil

#Detaljert:
#OK - Put multitple points in a graph

class TC_GraphTest < Test::Unit::TestCase

	def test_put_one()
		graph = Graph.new()
		graph.put(1, 2)
		points_expected = [[1,2]]
		assert_equal(points_expected, graph.points)
	end
	
	def test_put_multiple()
		graph = Graph.new()
		graph.put(1, 2)
		graph.put(6, 9)
		graph.put(20, 5000)
		
		points_expected = [[1, 2], [6, 9], [20, 5000]]
		assert_equal(points_expected,graph.points)
	end
		
	def test_one_point_graph_to_s
		graph = Graph.new()
		graph.put(1, 2)
		
		js = graph.to_s()
		js_expected = "[[1, 2]]"
		
		assert_equal(js_expected, js)
	end
	
	def test_simple_graph_to_s
		graph = Graph.new()
		graph.put(10, -2500)
		graph.put(10, 2500)

		js = graph.to_s()
		js_expected = "[[10, -2500], [10, 2500]]"
		
		assert_equal(js_expected, js)
	end
	
	def test_multiple_point_graph_to_s
		graph = Graph.new()
		graph.put(1, 2000)
		graph.put(1, 1500)
		graph.put(4, 600)
		graph.put(4, -600)
		graph.put(7, -1400)
		graph.put(10, -1000)
		
		js = graph.to_s()
		js_expected = "[[1, 2000], [1, 1500], [4, 600], [4, -600], [7, -1400], [10, -1000]]"
		
		assert_equal(js_expected, js)
	end
	
	def test_stepwise_graph()
		graph = Graph.new()
		graph.put(1, 200)
		graph.put(6, 400)
		graph.put(13, 1200)
		graph.put(20, 800)
		graph.stepwise = true
		
		points_expected = [[1, 200], [6, 200], [6, 400], [13, 400], [13, 1200], [20, 1200], [20, 800]]
		assert_equal(points_expected, graph.points)
	end

  def test_graph_values()
		graph = Graph.new()
		graph.put(1, 2)
		graph.put(6, 9)
		graph.put(20, 5000)

    graph_values = graph.values
		assert(graph_values.include?(2))
    assert(graph_values.include?(9))
    assert(graph_values.include?(5000))
    assert_equal(3, graph_values.length)
  end

  def test_graph_values_must_be_in_added_order()
		graph = Graph.new()
		graph.put(1, 2)
		graph.put(20, 5000)
		graph.put(6, 9)

    graph_values = graph.values
    graph_values_expected = [2, 5000, 9]
    assert_equal(graph_values_expected, graph_values)
  end

end