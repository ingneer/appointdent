# frozen_string_literal: true

module InitialData
  DAY_START = '08:00'
  DAY_END = '18:00'
  LUNCH_START = '12:00'
  LUNCH_END = '13:00'
  INTERVAL = 30
  HOUR_IN_DAY = 24
  MIN_IN_DAY = 24 * 60
  SEC_IN_DAY = 24 * 60 * 60

  SEARCH_RANGE = { from: '2021-01-04', to: '2021-01-07' }.freeze

  # The dentists' current appointments, these times are blocked.
  WEEKLY_APPOINTMENTS = [
    { from: '2021-01-04T10:15:00', to: '2021-01-04T10:30:00' },
    { from: '2021-01-05T11:00:00', to: '2021-01-05T11:30:00' },
    { from: '2021-01-05T15:30:00', to: '2021-01-05T16:30:00' },
    { from: '2021-01-06T10:00:00', to: '2021-01-06T10:30:00' },
    { from: '2021-01-06T11:00:00', to: '2021-01-06T12:30:00' },
    { from: '2021-01-06T17:30:00', to: '2021-01-06T18:00:00' }
  ].freeze
end
