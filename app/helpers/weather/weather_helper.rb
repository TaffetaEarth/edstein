module Weather
  class WeatherHelper
    def self.get_current
      Net::HTTP.get('dataservice.accuweather.com', "/currentconditions/v1/#{ENV['LOCATION_KEY']}?apikey=#{ENV['APIKEY']}")
    end

    def self.get_historical
      Net::HTTP.get('dataservice.accuweather.com', "/currentconditions/v1/#{ENV['LOCATION_KEY']}/historical/24?apikey=#{ENV['APIKEY']}")
    end
  end
end
