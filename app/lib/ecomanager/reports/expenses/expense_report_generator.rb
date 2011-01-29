require 'expense_report'

class ExpenseReportGenerator
  
  def initialize(
      transactions,
      time_unit,
      start_date,
      end_date)

    check_params(
      transactions,
      time_unit,
      start_date,
      end_date)

    @transactions = transactions
    @time_unit = time_unit
    @start_date = start_date
    @end_date = end_date
  end

  def check_params(
      transactions,
      time_unit,
      start_date,
      end_date)

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

  end

  def create_report()
    report = ExpenseReport.new()
    
    return report
  end

end