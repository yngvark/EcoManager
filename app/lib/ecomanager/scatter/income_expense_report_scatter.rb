require 'graph'
require 'report_chart'

class IncomeExpenseReportScatter < ReportChart

  def to_s()
    chart = Scatter.new()
    @graphs.values.each do |g|
      chart.add(g)
    end

    return chart.to_s
  end

end