require 'rails_helper'

RSpec.describe 'Weather API requests' do
  context 'current' do
    it 'returns correct reading' do
      get '/api/weather/current' do
        expect(JSON.parse(response.body)['time']).to eql(WeatherReading.last[:time])
      end
    end
  end

  context 'historical' do
    it 'returns correct list of readings in last 24 hours' do
      get '/api/weather/historical' do
        short_readings_list = Array.new
        readings = WeatherReading.where(time: (Time.now - 1.day)..).to_a
        readings.each do |reading|
          short_readings_list << {'time': reading[:time], 'temperature': reading[:temperature]}
        end
        expect(JSON.parse(response.body)).to eql(short_readings_list)
      end
    end

    it 'returns correct max value of temperature in last 24 hours' do
      get '/api/weather/historical/max' do
        expect(JSON.parse(response.body)).to eql(WeatherReading.where(time: (Time.now - 1.day)..).maximum(:temperature))
      end
    end

    it 'returns correct min value of temperature in last 24 hours' do
      get '/api/weather/historical/min' do
        expect(JSON.parse(response.body)).to eql(WeatherReading.where(time: (Time.now - 1.day)..).minimum(:temperature))
      end
    end

    it 'returns correct avg value of temperature in last 24 hours' do
      get '/api/weather/historical/avg' do
        expect(JSON.parse(response.body)).to eql(WeatherReading.where(time: (Time.now - 1.day)..).average(:temperature))
      end
    end
  end

  context 'by_time' do
    it 'returns correct reading by time' do
      get "/api/weather/by_time/#{(Time.now - 6.hours).to_i}" do
        reading = WeatherReading.where("time <= ?", Time.now - 6.hours).order('weather_readings.time DESC').limit(1)
        expect(JSON.parse(response.body)).to eql({'time': reading[:time], 'temperature': reading[:temperature]})
      end
    end
  end

  context 'health' do
    it 'returns 200 status' do
      get '/api/health' do
        expect(response.status).to eql(200)
      end
    end
  end
end
