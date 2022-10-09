class CreateWeatherReadings < ActiveRecord::Migration[7.0]
  def change
    create_table :weather_readings do |t|
      t.datetime :time
      t.float :temperature

      t.timestamps
    end
  end
end
