require 'net/http'

LOCATION_KEY = "PARIS"

module Weather
  class API < Grape::API
    version 'v1', using: :header, vendor: 'weather'
    prefix 'api'
    format :json

    resource :weather do
      desc 'Returns current weather'
      get :current do
        WeatherReading.select("time, temperature").last.as_json(:except => [:id])
      end

      resource :by_time do
        desc 'Returns weather readings by time'
        params do
          requires :time, type: Integer, desc: "Timestamp of required weather data"
        end
        route_param :time do
          get do
            reading = WeatherReading.select("time, temperature").where("time <= ?", Time.at(params[:time]).to_datetime).order('weather_readings.time DESC').limit(1)
            if reading.blank?
              status 404
            else
              reading.as_json(:except => [:id])
            end
          end
        end
      end

      desc 'Returns historical readings'
      resource :historical do

        desc 'Returns all historical readings in 24 hours'
        get :/ do
          WeatherReading.select("time, temperature").where(time: (Time.now - 1.day)..).as_json(:except => [:id])
        end

        desc 'Returns max temperature in 24 hours'
        get :max do
          JSON.generate(WeatherReading.where(time: (Time.now - 1.day)..).maximum(:temperature))
        end

        desc 'Returns min temperature in 24 hours'
        get :min do
          JSON.generate(WeatherReading.where(time: (Time.now - 1.day)..).minimum(:temperature))
          end

        desc 'Returns avg temperature in 24 hours'
        get :avg do
          JSON.generate(WeatherReading.where(time: (Time.now - 1.day)..).average(:temperature))
        end

      end
    end

    desc 'Returns server status'
    get :health do
      status 200
    end
  end
end
