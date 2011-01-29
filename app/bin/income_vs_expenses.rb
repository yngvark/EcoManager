require 'date'
require 'csv_importer'
require 'account'
require 'report_generator'
require 'income_expense_report_line_chart.rb'
require 'line_inserter'

# DESCRIPTION:
# See a scatter with graphs for my income, my expenses, the result, and the accumulated savings.

def create_report(csv_filename)
	time_interval = "month"
	start_date = Date.new(2010, 1, 1)
	end_date = Date.new(2010, 12, 31)
	@income_account = Account.new("Income")
	@expenses_account = Account.new("Expenses")
  transactions = import_csv(csv_filename)

	generator = ReportGenerator.new(
		transactions,
		time_interval,
		start_date,
		end_date,
		@income_account,
		@expenses_account)

	return generator.create_report()
end

def import_csv(csv_filename)
	csv_importer = CsvImporter.new()
	transactions = csv_importer.import(
    csv_filename, @income_account, @expenses_account)
	return transactions
end

def write_chart_to_file(out_filename, chart_js)
	# Write chart to file...
  li = LineInserter.new(out_filename)
  overwrites = [ "var data = " + chart_js + ";\n" ]
  search_for = "var data ="
  li.overwrite(search_for, overwrites)
end

def write_chart_labels_to_file(out_filename, labels_js)
	# Write chart to file...
  li = LineInserter.new(out_filename)
  overwrites = [ "line.Set('chart.labels', " + labels_js + ");\n" ]
  search_for = "line.Set('chart.labels'"
  li.overwrite(search_for, overwrites)
end

def array_to_js(arr)
  js = "[" + arr.join(", ") + "]"
  return js
end

def debug(report)
  report.income.each do |time, val|
    puts "Time: #{time} \t\t Value: #{val}"
  end
end

if __FILE__ == $0
  # Get javascript for report chart...
	report = create_report("income_vs_expenses2.csv")
  debug(report)
	chart = IncomeExpenseReportLineChart.new(report)
	chart_js = chart.to_s

  # Write report chart to HTML file...
  out_filename = "income_vs_expenses.html"
  write_chart_to_file(out_filename, chart_js)

  # Write report chart labels to HTML file...
  labels_js = array_to_js(chart.chart_labels)
  write_chart_labels_to_file(out_filename, labels_js)

	# Inform user...
	puts "Results written to file: " + out_filename
	
end