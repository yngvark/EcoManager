require 'test/unit'
require 'date'
require 'account'
require 'csv_importer'
require 'reports/income_expenses/income_expense_report_generator'

class TC_ReportGeneratorTest < Test::Unit::TestCase

  def setup()
    @time_unit = "month"
    @start_date = Date.new(2010, 7, 1)
    @end_date = Date.new(2010, 8, 31)
    @income_account = Account.new("Income")
    @expense_account = Account.new("Expenses")
    @transactions = import_csv(@income_account, @expense_account)

    @generator = IncomeExpenseReportGenerator.new(
      @transactions,
      @time_unit,
      @start_date,
      @end_date,
      @income_account,
      @expense_account)
  end

  def test_time_units_month
    report = @generator.create_report()

    time_axis = report.time_axis
    assert_equal("7", time_axis[0])
    assert_equal("8", time_axis[1])
  end

  def test_monthly_incomes
    report = @generator.create_report()

    income = report.income
    assert_equal(27257, income["7"])
    assert_equal(96001.6, income["8"])
  end

  def test_monthly_expenses
    report = @generator.create_report()

    expenses = report.expenses
    assert_equal(11261.37, expenses["7"])
    assert_equal(100882.42, expenses["8"])
  end

  def test_month_time_unit
    @generator.time_unit = "month"
    report = @generator.create_report()
    assert_equal("month", report.time_unit)
  end

  def test_time_units_week
    @generator.time_unit = "week"
    report = @generator.create_report()

    time_axis = report.time_axis
    for i in (26..35)
      assert_equal(i.to_s, time_axis[i - 26])
    end
  end

  def test_week_sums
    @generator.time_unit = "week"
    report = @generator.create_report()

    income = report.income
    expenses = report.expenses

    assert_equal(1257, income["26"])
    assert_equal(872.5, expenses["26"])

    assert_equal(0, income["35"])
    assert_equal(1531.74, expenses["35"])
  end

  def test_week_time_unit
    @generator.time_unit = "week"
    report = @generator.create_report()
    assert_equal("week", report.time_unit)
  end

  def test_invalid_transaction_raises_exception()
    assert_raise(ArgumentError) do
      IncomeExpenseReportGenerator.new(
        "A string instead of transactions",
        @time_unit,
        @start_date,
        @end_date,
        @income_account,
        @expense_account)
    end
  end
  
  private

  def import_csv(income_account, expenses_account)
    csv_importer = CsvImporter.new()
    transactions =
      csv_importer.import(
      "tc_report_generator.csv",
      income_account,
      expenses_account)
    
    return transactions
  end

end