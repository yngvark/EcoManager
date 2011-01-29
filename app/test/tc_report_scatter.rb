require 'test/unit'
require 'account'
require 'csv_importer'
require 'date'
require 'income_expense_report_scatter'
require 'report_generator'

# TODO:
# Test graphs:
# - Income minus expenses hash
# - Low Savings hash

class TC_ReportScatterTest < Test::Unit::TestCase

  def test_month_scatter_income()
    report = create_report("month")
    scatter = IncomeExpenseReportScatter.new(report)
    income_graph = scatter.get_graph_for(@income_account)

    graph_expected = Graph.new()
    graph_expected.put("7", 27257)
    graph_expected.put("8", 96001.6)

    assert_equal(graph_expected, income_graph)
  end

  def test_month_scatter_expenses()
    report = create_report("month")
    report_scatter = IncomeExpenseReportScatter.new(report)
    expenses_graph = report_scatter.get_graph_for(@expenses_account)

    graph_expected = Graph.new()
    graph_expected.put("7", 11261.37)
    graph_expected.put("8", 100882.42)

    assert_equal(graph_expected, expenses_graph)
  end

  def test_scatter_contains_correct_graphs()
    report = create_report("month")
    report_scatter = IncomeExpenseReportScatter.new(report)

    income_graph = report_scatter.get_graph_for(@income_account)
    expenses_graph = report_scatter.get_graph_for(@expenses_account)

    graphs = report_scatter.graphs
    
    assert(
      graphs.include?(income_graph), "Graphs doesn't include income graph")
    assert(
      graphs.include?(expenses_graph), "Graphs doesn't include expenses graph")
    assert(graphs.length == 2, "Number of graph is incorrect: #{graphs.length}")
  end

  def test_scatter_chart_labels_month()
    report = create_report("month")
    report_scatter = IncomeExpenseReportScatter.new(report)

    labels_expected = [ "7", "8" ]
    # ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    assert_equal(labels_expected, report_scatter.chart_labels)
  end

  def test_scatter_chart_labels_week()
    report = create_report("week")
    report_scatter = IncomeExpenseReportScatter.new(report)

    labels_expected = []
    for i in (26..35)
      labels_expected.push(i.to_s)
    end

    assert_equal(labels_expected, report_scatter.chart_labels)
  end

  def todo_test_print_js_from_report_scatter
    # Income_expense_report_scatter burde arve fra Scatter, slik at jeg bare kan printe ut
    # JS-ne fra ReportScatteren!
    # assert false
    report = create_report("month")
    report_scatter = IncomeExpenseReportScatter.new(report)

    income_graph = report_scatter.get_graph_for(@income_account)
    expenses_graph = report_scatter.get_graph_for(@expenses_account)

    s = report_scatter.scatter
    puts s
    #assert false
  end
  
  def TODO_test_income_minus_expenses()
    report = create_report("month")
    report_scatter = IncomeExpenseReportScatter.new(report)
    expenses_graph = report_scatter.get_graph_for(@expenses_account)

    graph_expected = Graph.new()
    graph_expected.put(7, -11261.37)
    graph_expected.put(8, -100882.42)

    assert_equal(graph_expected, expenses_graph)
  end

  private

  def create_report(time_interval)
    start_date = Date.new(2010, 7, 1)
    end_date = Date.new(2010, 8, 31)
    @income_account = Account.new("Income")
    @expenses_account = Account.new("Expenses")
    transactions = import_csv(@income_account, @expenses_account)

    generator = IncomeExpenseReportGenerator.new(
      transactions,
      time_interval,
      start_date,
      end_date,
      @income_account,
      @expenses_account)

    return generator.create_report()
  end

  def import_csv(income_account, expenses_account)
    csv_importer = CsvImporter.new()
    transactions =
      csv_importer.import(
      "tc_report_scatter.csv",
      income_account,
      expenses_account)

    return transactions
  end

end