# frozen_string_literal: true

class OutputService
  class << self
    # TODO
    def fine_print(results); end
  end
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
  #
  # # p (free_time_slots.transform_keys(&:to_s))
  # #
  # # fts = free_time_slots.transform_values do |a|
  # #   a.each_with_index.map do |val, index|
  # #     nex_el = a[index + 1]
  # #     next if nex_el.nil?
  # #
  # #     curr_val = val.strftime("%H:%M")
  # #     nex_val =  nex_el.strftime("%H:%M")
  # #
  # #     { from: curr_val, to: nex_val }
  # #   end
  # # end
end
