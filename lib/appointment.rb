# frozen_string_literal: true

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
