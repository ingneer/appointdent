#!/usr/bin/env ruby

# frozen_string_literal: true

require 'time'
require './lib/initial_data'
require './lib/appointment'
require './lib/appointments'
require './lib/utils/appointments_service'
require './lib/utils/output_service'
require './lib/utils/date_time_service'


results = AppointmentsService.find_free_timeslots

OutputService.fine_print(results)
