require 'test/unit'
require 'account'
require 'date'
require 'expense_report_generator'
require 'expense_report_line_chart'
require 'csv_importer'

class TC_ExpenseReportLineChartTest < Test::Unit::TestCase

  def test_js_expected()
    report = create_report("tc_expense_report_line_chart.csv")
    chart = ExpenseReportLineChart.new(report)

    # Apotek: [0.0, 162.0, 120.0, 0.0, 0.0, 0.0, 0.0, 500.0, 0.0, 0.0, 0.0, 0.0]
    # Bunnpris: [326.98, 620.6, 54.6, 171.5, 0.0, 1007.69, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    # OBOS: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 500.0, 0.0, 0.0, 0.0, 0.0]
    js_expected = "[[0.0, 162.0, 120.0, 0.0, 0.0, 0.0, 0.0, 500.0, 0.0, 0.0, 0.0, 0.0], [326.98, 620.6, 54.6, 171.5, 0.0, 1007.69, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 500.0, 0.0, 0.0, 0.0, 0.0]]"
    js = chart.to_s
    
    assert_equal(js_expected, js)
  end
  
  private

  def create_report(csv_filename)
    time_interval = "month"
    start_date = Date.new(2010, 1, 1)
    end_date = Date.new(2010, 12, 31)
    transactions = import_csv(csv_filename)

    # Hm this report generator is really customized to income expense stuff.
    # I think I should create a new generator, and when it's working, refactor
    # both of them to one if possible.
    
    generator = ExpenseReportGenerator.new(
      transactions,
      time_interval,
      start_date,
      end_date)
    
    return generator.create_report()
  end

  def import_csv(csv_filename)
    # Set up the credit accounts....
    appartement = Account.new("OBOS")
    groceries = Account.new("Bunnpris")
    drugstore = Account.new("Apotek")

    # Set up transaction filter...
    csv_importer = CsvImporter.new()
    csv_importer.transaction_filter = {
      "OBOS" => appartement,
      "Bunnpris" => groceries,
      "Apotek" => drugstore
    }

    transactions = csv_importer.import(csv_filename)
    
    return transactions
  end


end
