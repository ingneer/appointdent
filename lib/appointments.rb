# frozen_string_literal: true

class Appointments
  def self.new(date, appointments_array)
    date_t = date || Date.new
    appointments_array_t = appointments_array || []

    {}.tap do |ha|
      ha[date_t] = appointments_array_t
    end
  end
end
