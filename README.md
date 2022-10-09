API для статистики по погоде

Использованы фреймворки grape, rufus, rspec

Приложение построено на Rails 7, Ruby 3.1.2, запускается в контейнерах с помощью docker-compose, в качестве базы данных postgresql

/weather/current - Текущая температура
/weather/historical - Почасовая температура за последние 24 часа 
/weather/historical/max - Максимальная темперетура за 24 часа
/weather/historical/min - Минимальная темперетура за 24 часа
/weather/historical/avg - Средняя темперетура за 24 часа
/weather/by_time - Ближайшая температура к переданному timestamp 
/health - Статус бекенда (200)