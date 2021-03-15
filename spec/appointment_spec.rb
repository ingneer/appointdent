# frozen_string_literal: true

require "spec_helper"
require "appointment"

RSpec.describe "Appointment" do
  describe "new instance" do
    it "should return the proper format" do
      from = '2021-01-04T10:15:00'
      to = '2021-01-04T10:30:00'
      expect(Appointment.new(from, to)).to eq({ from: DateTime.parse(from), to: DateTime.parse(to) })
    end

    describe "when date string not properly formatted" do
      it "`:from` value should return the DateTime instance" do
        expect(Appointment.new('', '')[:from]).to be_instance_of(DateTime)
      end

      it "`:to` value should return the DateTime instance" do
        expect(Appointment.new('', '')[:to]).to be_instance_of(DateTime)
      end
    end
  end
end
