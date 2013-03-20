def workdays_between(start_date, end_date)
  day      = start_date
  workdays = 0

  while day <= end_date
    workdays += 1 unless day.saturday? or day.sunday?
    day += 1
  end

  workdays
end

def progress_bar(options = {})
  options = {
    label: nil,
    hours:   0,
    total:   0,
    missing: 0,
    length: 100,
  }.merge(options)

  label   = options.delete(:label)
  hours   = options.delete(:hours)
  total   = options.delete(:total)
  missing = options.delete(:missing)
  rest    = total - hours - missing
  length  = options.delete(:length)

  unit                = length.to_f / 100
  hours_percent       = hours.to_f / total * 100
  missing_percent     = missing.to_f / total * 100

  hours_area_raw      = hours_percent * unit
  hours_area_length   = hours_area_raw.round
  hours_area_length   = 0 if hours_area_length < 0

  missing_area_raw    = missing_percent * unit
  hours_and_missing_area_length = (hours_area_raw + missing_area_raw).round
  missing_area_length = hours_and_missing_area_length - hours_area_length
  missing_area_length = 0 if missing_area_length < 0

  rest_area_length    = length - hours_area_length - missing_area_length
  rest_area_length    = 0 if rest_area_length < 0

  hours_area_length = length if hours_area_length > length

  puts label if label
  area hours, hours_area_length, :black, :green
  area missing, missing_area_length, :black, :yellow
  area rest, rest_area_length, :black, :red

  puts if label
  puts
end

def area(label, length, foreground, background)
  if length > 1
    label.to_s.center(length)
  elsif length == 1
    label.to_s[0]
  else ''
  end.each_char { |letter| print letter.color(foreground).background(background) }
end

def test(total, missing)
  puts
  (0..total).to_a.each do |hours|
    progress_bar hours: hours, total: total
    less_hours = (0.5 * hours).round
    missing = hours - less_hours
    progress_bar hours: less_hours, total: total, missing: missing
    puts
  end
end
