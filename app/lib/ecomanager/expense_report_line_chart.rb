require 'line_chart'
require 'expense_report'

class ExpenseReportLineChart

  def initialize(expenses_report)
    if !expenses_report.is_a?(ExpenseReport)
      raise(ArgumentError, "Argument must be an ExpenseReport!")
    end
    init_graphs(expenses_report)
  end

  def graphs()
    accounts_sorted = sorted_keys_of(@graphs) { |x,y| x <=> y }

    values = []
    accounts_sorted.each do |account|
      values.push(get_graph_for(account))
    end

    return values
  end

  private

  def init_graphs(expenses_report)
    # Create graphs for all accounts in report...

    expenses_report.accounts.each do |account|
      @graphs[account] = create_graph_for(account)
    end
  end

  def create_graph_for(account)
    
  end

  def sorted_keys_of(hash)
    if !hash.is_a?(Hash)
      raise "Argument must be a Hash!"
    end

    keys = hash.keys()
    keys.sort! { |x,y| yield(x,y) }

    return keys
  end

  def get_graph_for(account)
    return @graphs[account]
  end

  def to_s()
    chart = LineChart.new()

    graphs().each do |graph|
      chart.add(graph)
    end

    return chart.to_s
  end

end