# frozen_string_literal: true

class DateTimeService
  class << self
    include InitialData

    def add_date_hours_minutes(date, hours_minutes)
      date.to_datetime +
        time_fraction(hours_minutes[:hours], HOUR_IN_DAY) +
        time_fraction(hours_minutes[:minutes], MIN_IN_DAY)
    end

    def format_search_dates(search_range)
      (Date.parse(search_range[:from])...Date.parse(search_range[:to]))
    end

    def format_hours_minutes(hours_minutes)
      time_in_hm = hours_minutes.split(':')
      { hours: time_in_hm[0].to_i, minutes: time_in_hm[1].to_i }
    end

    def set_date_intervals(from, to, num, den)
      from.step(to, time_fraction(num, den))
    end

    def time_fraction(num, den)
      Rational(num, den)
    end
  end
end
