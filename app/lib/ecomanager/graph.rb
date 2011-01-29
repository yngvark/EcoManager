require 'ostruct'

# Points can be added to a graph. Then, a matrix containing the points can be retrieved.
class Graph

	# Set to true to let the graph be shown as a step graph, that is, a graph with only horizontal and vertical lines
	attr_accessor :stepwise
	
	def initialize()
		@points = []
		@stepwise = false
	end
	
	def put(x, y)
		@points.push([x, y])
	end
	
	def to_s()
		result = "["
		result += points_to_string()
		result += "]"
		
		return result
	end
		
	def points()
		if stepwise
			return points_stepwise()
		else
      return @points
		end
	end

  def ==(other)
    if other == nil
      return false
    elsif other.class == Graph
      return self.points == other.points
    else
      return false
    end
  end
  
  def values()
    values = []
    @points.each do |p|
      values.push(p[1])
    end
    
    return values
  end

	private
	
	def points_to_string()
		point_separator = ", "
		string = ""
		
		points.each do |point|
			point_s = point_to_string(point)
			string += point_s + ", "
		end
		
		# Remove the last point separator from the string.
		string = string[0, string.length - point_separator.length]
		
		return string
	end
	
	def point_to_string(point)
		return "[" + point[0].to_s() + ", " + point[1].to_s()  + "]"
	end

	def points_stepwise()
		points_stepwise = [ @points[0] ]
		(1..@points.length - 1).each do |i|
			point = @points[i]
			last_point = @points[i - 1]
			
			# Create a point, such that a possible slope is replaced by a straight line.
			step_point = [point[0], last_point[1]]

			points_stepwise.push(step_point)
			points_stepwise.push(point)
		end
		return points_stepwise
	end
	
end
