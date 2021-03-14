# frozen_string_literal: true

require 'time'

# This is the range where our patient wants to have an appointment
# TODO: Check if the `:to` is inclusive or exclusive; Go with exclusive.
search_range = { from: '2021-01-04', to: '2021-01-07' }

# The dentists' current appointments, these times are blocked.
weekly_appointments = [
  { from: '2021-01-04T10:15:00', to: '2021-01-04T10:30:00' },
  { from: '2021-01-05T11:00:00', to: '2021-01-05T11:30:00' },
  { from: '2021-01-05T15:30:00', to: '2021-01-05T16:30:00' },
  { from: '2021-01-06T10:00:00', to: '2021-01-06T10:30:00' },
  { from: '2021-01-06T11:00:00', to: '2021-01-06T12:30:00' },
  { from: '2021-01-06T17:30:00', to: '2021-01-06T18:00:00' }
]

# FIXME: actual date objects could be useful...
DAY_START = '08:00'
DAY_END = '18:00'
LUNCH_START = '12:00'
LUNCH_END = '13:00'
INTERVAL = 30
HOUR_IN_DAY = 24
MIN_IN_DAY = 24 * 60
SEC_IN_DAY = 24 * 60 * 60

module DefaultsAndConstants
  DAY_START = '08:00'
  DAY_END = '18:00'
  LUNCH_START = '12:00'
  LUNCH_END = '13:00'
  INTERVAL = 30
  HOUR_IN_DAY = 24
  MIN_IN_DAY = 24 * 60
  SEC_IN_DAY = 24 * 60 * 60
end

class Appointment
  attr_reader :from, :to

  def initialize(from, to)
    @from = from
    @to = to
  end

  class << self
    def new(from, to)
      from_t = parse_date_time(from)
      to_t = parse_date_time(to)

      { from: from_t, to: to_t }
    end

    def parse_date_time(str)
      DateTime.parse(str)
    rescue StandardError => _e
      DateTime.now
    end
  end
end

class DailyAppointments
  attr_reader :date, :appointments_array

  def initialize(date, appointments_array)
    @date = date || Date.now
    @appointments_array = appointments_array || []
  end

  def self.new(date, appointments_array)
    {}.tap do |ha|
      ha[date] = appointments_array
    end
  end
end

# TODO: implement this
# def find_free_timeslots; end

class Appointments
  attr_reader :timeslots

  def initialize(timeslots)
    @timeslots = timeslots
  end

  def grouped_daily
    grouped_by_date.map do |date, appointments|
      DailyAppointments.new(date, appointments)
    end
  end

  private

  def grouped_by_date
    @grouped_by_date ||= formatted_timeslots.group_by { |weekly_entry| weekly_entry[:from].to_date }
  end

  def formatted_timeslots
    @formatted_timeslots ||= [].tap do |arr|
      timeslots.each do |wa|
        arr << Appointment.new(wa[:from], wa[:to])
      end
    end
  end
end

class DataFormatService
  class << self
    def format_weekly_appointments(appointments)
      weeklys = appointments.map do |timeslot|
        timeslot.transform_values { |value| DateTime.parse(value) }
      end
      weeklys.group_by { |h| h[:from] }
    end

    def format_search_dates(search_range)
      (Date.parse(search_range[:from])...Date.parse(search_range[:to]))
    end

    def format_hours_minutes(hours_minutes)
      time_in_hm = hours_minutes.split(':')
      { hours: time_in_hm[0].to_i, minutes: time_in_hm[1].to_i }
    end
  end
end

class DateTimeService
  class << self
    def add_date_hours_minutes(date, hours_minutes)
      date.to_datetime +
        time_fraction(hours_minutes[:hours], HOUR_IN_DAY) +
        time_fraction(hours_minutes[:minutes], MIN_IN_DAY)
    end

    def set_date_intervals(from, to, num, den)
      from.step(to, time_fraction(num, den))
    end

    def time_fraction(num, den)
      Rational(num, den)
    end
  end
end

prebooked_daily = Appointments.new(weekly_appointments).grouped_daily

search_dates = DataFormatService.format_search_dates(search_range)

day_start = DataFormatService.format_hours_minutes(DAY_START)
day_end = DataFormatService.format_hours_minutes(DAY_END)
lunch_start = DataFormatService.format_hours_minutes(LUNCH_START)
lunch_end = DataFormatService.format_hours_minutes(LUNCH_END)

# perpetual_timeslots = { from: lunch_start, to: lunch_end }

# A FIX for line 19 comment
# daily_worktime = {}.tap do |ha|
#   search_dates.each do |date|
#     from = add_date_hours_minutes(date, day_start)
#     to = add_date_hours_minutes(date, day_end)
#     ha[date.to_s] = { from: from, to: to }
#   end
# end

# Appointments service ->
def add_perpetual_breaks; end
perpetual_breaks = {}.tap do |ha|
  search_dates.each do |date|
    from = DateTimeService.add_date_hours_minutes(date, lunch_start)
    to = DateTimeService.add_date_hours_minutes(date, lunch_end)
    ha[date] = { from: from, to: to }
  end
end

def calculate_appointment_times; end
daily_worktime_ranges = {}.tap do |ha|
  search_dates.each do |date|
    from = DateTimeService.add_date_hours_minutes(date, day_start)
    to = DateTimeService.add_date_hours_minutes(date, day_end)
    ha[date] = DateTimeService.set_date_intervals(from, to, INTERVAL, MIN_IN_DAY)
  end
end

def set_booked_timeslots; end
blocked_timeslots = prebooked_daily.map do |ha|
  ha[ha.keys.first] << perpetual_breaks[ha.keys.first]
  ha.each { |_k, v| v.sort_by! { |haa| haa[:from] } }
end

def find_free_timeslots; end
free_blocks = {}.tap do |ha|
  daily_worktime_ranges.each do |k, v|
    ha[k] = v.reject do |ts|
      blocked = blocked_timeslots.dig(0, k)
      next if blocked.nil?

      blocked.any? do |bts|
        (bts[:from]...bts[:to]).cover?(ts) ||
          (ts...(ts + DateTimeService.time_fraction(INTERVAL, MIN_IN_DAY))).cover?(bts[:from])
      end
    end
  end
end

p free_blocks

# Formatter service ->
# free_times = free_blocks.transform_values { |arr| arr.map { |el| el.to_s } }
#
# booked_times = {}.tap do |hash|
#   blocked_timeslots.each do |k, v|
#     hash[k] = v.map { |ha| ha.transform_values { |el| el.to_s } }
#   end
# end
#
# puts "Free time slots for a selected search range and interval of #{INTERVAL} minutes"
# p free_times
# puts
# puts 'Pre-booked times'
# p booked_times
