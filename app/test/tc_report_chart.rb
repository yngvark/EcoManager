require 'test/unit'
require 'account'
require 'date'
require 'csv_importer'
require 'report_generator'
require 'graph'
require 'income_expense_report_line_chart'

class TC_ReportChartTest < Test::Unit::TestCase

  def test_graphs_must_always_be_in_same_order()
    report = create_report("tc_report_chart.csv")
    chart = IncomeExpenseReportLineChart.new(report)
    graphs = chart.graphs()
    constant_graphs = []
    
    for i in (0..graphs.length - 1)
      constant_graphs[i] = graphs[i]
    end

    for n in (0...500000)
      for ix in (0..graphs.length - 1)
        graphs = chart.graphs
        if graphs[ix] != constant_graphs[ix]
          assert(false, "Graph order should be the same for every call, but
            did change!")
        end
      end
    end

    assert(true)
  end

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

end