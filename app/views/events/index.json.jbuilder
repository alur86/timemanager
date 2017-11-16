json.array!(@events) do |event|
  json.extract! event, :title, :start_date, :start_time, :location, :agenda, :address, :organizer_id
  json.url event_url(event, format: :json)
end
