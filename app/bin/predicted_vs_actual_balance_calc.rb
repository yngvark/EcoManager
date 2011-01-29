require 'scatter'
require 'graph'
require 'account'
require 'transaction'
require 'date'

# DESCRIPTION:
# Predicted balance in the middle of the month. In contrast to usecase2.rb, this file actually
# calculates the balance graph based on transactions, rather than just producing a fixed graph.

if __FILE__ == $0
	# Input
	bank = Account.new()
	someone = Account.new()
	
	trans1 = Transaction.new(bank, someone, Date.new(2010, 8, 1), 3400)
	trans2 = Transaction.new(bank, someone, Date.new(2010, 8, 4), -800) # 2600
	trans3 = Transaction.new(bank, someone, Date.new(2010, 8, 10), -300) # 2300
	trans4 = Transaction.new(bank, someone, Date.new(2010, 8, 12), 500) # 2800
	trans5 = Transaction.new(bank, someone, Date.new(2010, 8, 16), -200) # 2600

	# Output
	posts = bank.posts
	
	# Create diagram
	scatter = Scatter.new()
	
	# Plot Today
	graph = Graph.new()
	graph.put(10, 0)
	graph.put(10, 4000)
	scatter.add(graph)	
	
	# Plot the balance history
	graph = Graph.new()
	#graph.stepwise = true
	posts.each do |post|
		x = post.transaction.date.day
		y = post.balance
		puts "x: #{x} , y:#{y}"
		graph.put(x, y)
	end
	scatter.add(graph)
	
	# Write results to file...
	js = scatter.to_s()
	out_filename = "predicted_vs_actual_balance_calc.txt"
	open(out_filename, 'w') do |f|
		f << js
	end
	
	# Inform user...
	puts "Results written to file: " + out_filename
	
	
end