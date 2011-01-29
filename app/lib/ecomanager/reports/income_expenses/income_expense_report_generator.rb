require File.expand_path('..', __FILE__) + '/income_expense_report'

class IncomeExpenseReportGenerator

  attr_accessor :time_unit
  
  def initialize(
      transactions,
      time_unit,
      start_date,
      end_date,
      income_account,
      expenses_account)

    check_params(
      transactions,
      time_unit,
      start_date,
      end_date,
      income_account,
      expenses_account)

    @transactions = transactions
    @time_unit = time_unit
    @start_date = start_date
    @end_date = end_date
    @income_account = income_account
    @expenses_account = expenses_account
  end

  def create_report()
    @report = IncomeExpenseReport.new(@income_account, @expenses_account)
    @report.time_unit = @time_unit
    @report.time_axis = create_time_axis(@time_unit, @start_date, @end_date)
    calc_income_expenses()
    return @report
  end

  private

  def check_params(
      transactions,
      time_unit,
      start_date,
      end_date,
      income_account,
      expenses_account)

    if !transactions.is_a?(Array)
      raise(ArgumentError, "Transactions was not an Array")
    end

    if !time_unit.is_a?(String)
      raise(ArgumentError, "Time unit was not a String: #{time_unit.class}")
    end

    if !start_date.is_a?(Date)
      raise(ArgumentError, "Start date was not a Date")
    end

    if !end_date.is_a?(Date)
      raise(ArgumentError, "End date was not a Date")
    end

    if !income_account.is_a?(Account)
      raise(ArgumentError, "Income account was not an Account")
    end

    if !expenses_account.is_a?(Account)
      raise(ArgumentError, "Expenses account was not an Account")
    end
  end

  def create_time_axis(time_unit, start_date, end_date)
    case time_unit
    when "week"
      return weeks_between(start_date, end_date)
    when "month"
      return months_between(start_date, end_date)
    end
  end

  def weeks_between(start_date, end_date)
    weeks = []
    start_week = start_date.cweek
    end_week = end_date.cweek

    for i in (start_week..end_week)
      weeks.push(i.to_s)
    end

    return weeks
  end

  def months_between(start_date, end_date)
      month_start = start_date.month
      month_end = end_date.month
      months = []

      for i in (month_start..month_end)
        months.push(i.to_s)
      end

      return months
  end

	def calc_income_expenses()
    init_amounts()

    @transactions.each do |transaction|
      if !transaction_date_is_within_report_timespan(transaction)
        next
      end

      add_amount_from(transaction)
    end
	end

  def init_amounts()
    @report.income = {}
    @report.expenses
    @report.expenses = {}

    # Refactor: Do @report.time_axis = generated_time_axis
    @report.time_axis.each do |time_unit|
      @report.income[time_unit] = 0
      @report.expenses[time_unit] = 0
    end
  end

  def transaction_date_is_within_report_timespan(transaction)
    return transaction.date - @start_date >= 0 && @end_date - transaction.date >= 0
  end

  def add_amount_from(t) # t: transaction
    time_unit = get_time_unit_from(t.date)

    if @income_account == t.debit_account
      @report.income[time_unit] += t.amount
    elsif @income_account == t.credit_account
      @report.expenses[time_unit] += t.amount
    else
      raise Exception.new("THIS THING MUST BE ADDRESSED")
      puts "****"
      puts t
      puts "****"
      #puts "Income account: #{@income_account} VS t.debit account: #{t.debit_account}"
      #puts "Income account: #{@expenses_account} VS t.debit account: #{t.credit_account}"
      #puts "Transaction's debit account: #{t.debit_account} VS Transaction's credit account: #{t.credit_account}"
    end
  end

  def get_time_unit_from(date)
    case @time_unit
    when "week"
      return date.cweek.to_s
    when "month"
      return date.month.to_s
    end
  end

end