require 'graph'
require 'line_chart'

# TODO: Find better name than "ReportChart", because it sounds like it should
# inherit from Chart, like LineChart does (though Scatter also inherits from
# Chart, even if it's not called ScatterChart).

class ReportChart

  attr_reader :chart_labels

  # income_expense_report   A completet income expense report.
  def initialize(income_expense_report)
    init_chart_labels(income_expense_report)
    init_graphs(income_expense_report)
    #do_test()
  end

  def get_graph_for(account)
    return @graphs[account]
  end

  # Returns the graphs of this chart, sorted by the account the graph is
  # showing. See account class for how accounts are sorted.
  def graphs()
    accounts_sorted = sorted_keys_of(@graphs) { |x,y| x <=> y }

    values = []
    accounts_sorted.each do |account|
      values.push(get_graph_for(account))
    end
    
    return values
  end

  private

  def init_chart_labels(income_expense_report)
    @chart_labels = income_expense_report.time_axis
  end


end