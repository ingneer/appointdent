# frozen_string_literal: true

class OutputService
  class << self
    include InitialData

    def fine_print(results)
      prepare_results(results).each do |k, v|
        total_length = v.first[:from].to_s.length + ' to '.length + v.first[:from].to_s.length
        puts '=' * total_length
        puts k
        puts '*' * total_length
        v.each { |kk, _vv| puts "#{kk[:from]} to #{kk[:to]}" }
        puts '*' * total_length
      end
    end

    def prepare_results(results)
      results_modified = prepare_values(results)
      results_modified.transform_keys { |k| k.to_date.to_s }
    end

    def prepare_values(results)
      results.transform_values do |a|
        a.map do |val|
          next_val = (val + DateTimeService.time_fraction(INTERVAL, MIN_IN_DAY))
          { from: val.strftime("%H:%M"), to: next_val.strftime("%H:%M") }
        end
      end
    end
  end
end
