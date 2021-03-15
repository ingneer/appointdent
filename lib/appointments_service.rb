# frozen_string_literal: true

class AppointmentsService
  class << self
    include InitialData

    def find_free_timeslots
      @find_free_timeslots ||= {}.tap do |ha|
        appointment_time_ranges.each do |k, v|
          ha[k] = selected_timeslots(v, k)
        end
      end
    end

    def booked_timeslots
      @booked_timeslots ||= weekly_appointments.map do |ha|
        ha[ha.keys.first] << perpetual_timeslots[ha.keys.first]
        ha.each { |_k, v| v.sort_by! { |haa| haa[:from] } }
      end
    end

    def weekly_appointments
      grouped_by_date.map do |date, appointments|
        DailyAppointments.new(date, appointments)
      end
    end

    def perpetual_timeslots
      {}.tap do |ha|
        search_dates.each do |date|
          from = DateTimeService.set_hours_minutes(date, lunch_start)
          to = DateTimeService.set_hours_minutes(date, lunch_end)
          ha[date] = { from: from, to: to }
        end
      end
    end

    def appointment_time_ranges
      @appointment_time_ranges ||= {}.tap do |ha|
        search_dates.each do |date|
          from = DateTimeService.set_hours_minutes(date, day_start)
          to = DateTimeService.set_hours_minutes(date, day_end)
          ha[date] = DateTimeService.set_date_intervals(from, to, INTERVAL, MIN_IN_DAY)
        end
      end
    end

    private

    # timeslot is blocked if
    #   it is covered by the booked appointment range OR
    #   range between timeslot and interval_addition (in minutes) covers the booked timeslot OR
    #   range between timeslot and interval_addition (in minutes) covers the time when work-day ends
    def any_blocked?(booked_appointments, free_timeslot)
      interval = DateTimeService.time_fraction(INTERVAL, MIN_IN_DAY)
      booked_appointments.any? do |booked_timeslot|
        booked_timeslot_range = booked_timeslot[:from]...booked_timeslot[:to]
        interval_addition_range = free_timeslot...(free_timeslot + interval)
        day_ends = DateTimeService.set_hours_minutes(free_timeslot.to_date, day_end)

        booked_timeslot_range.cover?(free_timeslot) ||
          interval_addition_range.cover?(booked_timeslot[:from]) ||
          interval_addition_range.cover?(day_ends)
      end
    end

    def booked_values(booked_timeslots, k)
      [].tap do |arr|
        booked_timeslots.each_index do |index|
          arr.push(booked_timeslots.dig(index, k))
        end
      end.compact.flatten
    end

    def selected_timeslots(timeslots_values, key)
      timeslots_values.reject do |free_timeslot|
        any_blocked?(booked_values(booked_timeslots, key), free_timeslot)
      end
    end

    def grouped_by_date
      @grouped_by_date ||= formatted_timeslots.group_by { |weekly_entry| weekly_entry[:from].to_date }
    end

    def formatted_timeslots
      @formatted_timeslots ||= [].tap do |arr|
        WEEKLY_APPOINTMENTS.each do |wa|
          arr << Appointment.new(wa[:from], wa[:to])
        end
      end
    end

    def search_dates
      @search_dates ||= DateTimeService.format_search_dates(SEARCH_RANGE)
    end

    def day_start
      DateTimeService.format_hours_minutes(DAY_START)
    end

    def day_end
      DateTimeService.format_hours_minutes(DAY_END)
    end

    def lunch_start
      DateTimeService.format_hours_minutes(LUNCH_START)
    end

    def lunch_end
      DateTimeService.format_hours_minutes(LUNCH_END)
    end
  end
end
