require 'rufus/scheduler'

scheduler = Rufus::Scheduler.singleton

scheduler.every '1h' do
  reading = JSON.parse(Weather::WeatherHelper.get_current)
  time = reading['LocalObservationDateTime']
  if WeatherReading.where('time' => time).blank?
    temp = JSON.parse(reading)['Temperature']['Metric']['Value']
    WeatherReading.new(time: time, temperature: temp).save
  end
end

scheduler.in '1s' do
  readings = JSON.parse(Weather::WeatherHelper.get_historical)
  readings.each do |reading|
    time = reading['LocalObservationDateTime']
    if WeatherReading.where('time' => time).blank?
      temp = reading['Temperature']['Metric']['Value']
      WeatherReading.new(time: time, temperature: temp).save
    end
  end
end
