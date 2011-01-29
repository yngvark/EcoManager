require 'graph'
require 'line_chart'
require 'report_chart'

class IncomeExpenseReportLineChart < ReportChart

  def to_s()
    chart = LineChart.new()

    graphs().each do |graph|
      chart.add(graph)
    end

    return chart.to_s
  end

  private

  def init_graphs(income_expense_report)
    income_account = income_expense_report.income_account
    expenses_account = income_expense_report.expenses_account

    @graphs = {
      income_account => income_graph(income_expense_report),
      expenses_account => expenses_graph(income_expense_report)
      }
  end

  def income_graph(income_expense_report)
    times = sorted_keys_of(income_expense_report.income) { |x,y| str_to_float_comparator(x, y) }
    return get_graph_for_hash_and_keys(income_expense_report.income, times)
  end

  def sorted_keys_of(hash)
    if !hash.is_a?(Hash)
      raise Exception("Argument must be a Hash!")
    end

    keys = hash.keys()
    keys.sort! { |x,y| yield(x,y) }

    return keys
  end

  def str_to_float_comparator(x, y)
    return x.to_f <=> y.to_f
  end

  def get_graph_for_hash_and_keys(hash, keys)
    g = Graph.new()
    keys.each do |key|
      value = hash[key]
      g.put(key, value)
    end

    return g
  end

  def expenses_graph(income_expense_report)
    times = sorted_keys_of(income_expense_report.expenses) { |x,y| str_to_float_comparator(x, y) }
    return get_graph_for_hash_and_keys(income_expense_report.expenses, times)
  end
  
end