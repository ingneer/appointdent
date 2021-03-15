# frozen_string_literal: true

class Appointments
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
