#!/usr/bin/env ruby

require 'trollop'
require 'rainbow'
require 'terminal-table'
require 'active_support/core_ext'
#require 'pry'
require './lib'

opts = Trollop.options do
  opt :hours,   'Hours you worked this month', :type => :int, :default => 6
  opt :per_day, 'Hours you work per day',      :type => :int, :default => 6
  opt :rate,    'Your income rate per hour',   :type => :int
  opt :test,    'Run visual test :)',          :type => :bool
end

test = opts[:test]

# General config
today              = Date.today
beginning_of_month = today.at_beginning_of_month
end_of_month       = today.at_end_of_month
workdays_total     = workdays_between beginning_of_month, end_of_month
workdays_passed    = workdays_between beginning_of_month, today

hours_actual       = !ARGV.first.to_i.zero? ? ARGV.first.to_i : opts[:hours]
hours_per_day      = opts[:per_day]
hours_total        = workdays_total * hours_per_day
hours_progressed   = workdays_passed * hours_per_day
hours_missing      = hours_progressed - hours_actual
hours_approximated = (hours_actual.to_f / workdays_passed * workdays_total).round

if opts[:rate]
  income_hour_rate    = opts[:rate]
  income_actual       = hours_actual * income_hour_rate
  income_approximated = hours_approximated * income_hour_rate
end

if test
  puts " 100 ".center(100, '=')
  test hours_total, hours_missing
else
  puts
  table = Terminal::Table.new do |t|
    t << [ { value: 'Hours!', colspan: 2, alignment: :center } ]
    t << :separator
    t << [ { value: 'Workdays total'      }, { value: workdays_total,      :alignment => :right } ]
    t << [ { value: 'Workdays passed'     }, { value: workdays_passed,     :alignment => :right } ]
    t << [ { value: 'Hours per day'       }, { value: hours_per_day,       :alignment => :right } ]
    t << [ { value: 'Hours total'         }, { value: hours_total,         :alignment => :right } ]
    t << [ { value: 'Hours progressed'    }, { value: hours_progressed,    :alignment => :right } ]
    t << [ { value: 'Your hours'          }, { value: hours_actual,        :alignment => :right } ]
    t << [ { value: 'Hours missing'       }, { value: hours_missing,       :alignment => :right } ]
    t << [ { value: 'Hours approximated'  }, { value: hours_approximated,  :alignment => :right } ]
    t << [ { value: 'Income actual'       }, { value: income_actual,       :alignment => :right } ] if opts[:rate]
    t << [ { value: 'Income approximated' }, { value: income_approximated, :alignment => :right } ] if opts[:rate]
  end
  puts table
  puts
  progress_bar label: 'Total hours', hours: hours_progressed, total: hours_total
  progress_bar label: 'Your hours', hours: hours_actual, total: hours_total, missing: hours_missing
  progress_bar label: 'End-of-month approximation', hours: hours_approximated, total: hours_total
end