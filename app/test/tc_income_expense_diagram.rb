require 'test/unit'
require 'account'
require 'date'
require 'csv_importer'
require 'reports/income_expenses/income_expense_diagram'

class TC_IncomeExpenseDiagramTest < Test::Unit::TestCase

  def test_js_expected()
    report = create_report("tc_income_expense_report_line_chart.csv")
    chart = IncomeExpenseDiagram.new(report)

    js_expected = "[[596.98, 1813.7, 1228.32, 746.16, 214.0, 1085.69, 794.0, 9633.31, 0.0, 0.0, 0.0, 0.0], [22698.0, 11000.0, 347.0, 1210.0, 0.0, 0.0, 7257.0, 0.0, 0.0, 0.0, 0.0, 0.0]]";
    js = chart.to_s
    
    assert_equal(js_expected, js)
  end
  
  private

  def create_report(csv_filename)
    time_interval = "month"
    start_date = Date.new(2010, 1, 1)
    end_date = Date.new(2010, 12, 31)
    @income_account = Account.new("Income")
    @expenses_account = Account.new("Expenses")
    transactions = import_csv(csv_filename)

    generator = IncomeExpenseReportGenerator.new(
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
