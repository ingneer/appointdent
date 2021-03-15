# frozen_string_literal: true

class AppointmentsService
  class << self
    include InitialData

    def find_free_timeslots
      @find_free_timeslots ||= {}.tap do |ha|
        appointment_time_ranges.each do |k, v|
          ha[k] = v.reject do |free_timeslot|
            booked_t = booked_timeslots
            booked = [].tap do |arr|
              booked_t.each_index do |index|
                arr.push(booked_t.dig(index, k))
              end
            end.compact.flatten

            # TODO: Get rid of the DAY_END times (the last appointment should come just before the DAY_END time)
            #  example: DAY_END = 18:00, the last appointment should be 17:30, if interval is 30 minutes

            # TODO: Format the output right here
            #   if the timeslot gets rejected, that should be the last :from element
            #   and loop should add a new block time from the next element in succession
            any_blocked?(booked, free_timeslot)
          end
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
          from = DateTimeService.add_date_hours_minutes(date, lunch_start)
          to = DateTimeService.add_date_hours_minutes(date, lunch_end)
          ha[date] = { from: from, to: to }
        end
      end
    end

    def appointment_time_ranges
      @appointment_time_ranges ||= {}.tap do |ha|
        search_dates.each do |date|
          from = DateTimeService.add_date_hours_minutes(date, day_start)
          to = DateTimeService.add_date_hours_minutes(date, day_end)
          ha[date] = DateTimeService.set_date_intervals(from, to, INTERVAL, MIN_IN_DAY)
        end
      end
    end

    private

    # timeslot is blocked if it is covered by the booked appointment range
    # or if combined length of free time slot and interval (in minutes) covers the booked datetime
    def any_blocked?(booked_appointments, free_timeslot)
      booked_appointments.any? do |booked_datetime|
        (booked_datetime[:from]...booked_datetime[:to]).cover?(free_timeslot) ||
          (free_timeslot...(free_timeslot + DateTimeService.time_fraction(INTERVAL, MIN_IN_DAY))).cover?(booked_datetime[:from])
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
      @search_dates = DateTimeService.format_search_dates(SEARCH_RANGE)
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
