# frozen_string_literal: true

require "spec_helper"
require "appointments"

RSpec.describe "Appointments" do
  describe "new instance" do
    from = '2021-01-04T10:15:00'
    to = '2021-01-04T10:30:00'
    date = Date.parse(from)
    appointments_list = [Appointment.new(from, to)]

    it "should return the proper format" do
      expect(Appointments.new(date, appointments_list)).to eq({ date => appointments_list })
    end

    describe "when date and appointments list are missing" do
      it "keys should be instances of Date" do
        expect(Appointments.new(nil, nil).keys.first).to be_instance_of(Date)
      end

      it "values should be instance of Array" do
        expect(Appointments.new(nil, nil).values).to be_instance_of(Array)
      end
    end
  end
end
