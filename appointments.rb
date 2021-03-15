# frozen_string_literal: true

require 'time'
require './lib/initial_data'
require './lib/appointment'
require './lib/daily_appointments'
require './lib/appointments_service'
require './lib/utils/output_service'
require './lib/utils/date_time_service'


free_time_slots = AppointmentsService.find_free_timeslots


