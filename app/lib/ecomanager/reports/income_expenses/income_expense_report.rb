class IncomeExpenseReport

  attr_accessor :time_axis

  # Example: "month"
  attr_accessor :time_unit

  # Example: { "1" => 402, "2" => 602.5, ... "12" => 901 }
  attr_accessor :income, :expenses

  attr_reader :income_account, :expenses_account

  def initialize(income_account, expenses_account)
    @income_account = income_account
    @expenses_account = expenses_account
  end

end