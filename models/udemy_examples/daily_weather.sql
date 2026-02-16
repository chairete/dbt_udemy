WITH daily_weather AS (
  SELECT date(time) as daily_weather,
  weather,
  temp,
  pressure,
  humidity,
  clouds
  FROM {{ source('demo', 'weather') }}
 --order by time desc
), daily_weather_agg as (
  SELECT daily_weather,
  weather,
  COUNT(weather),
  round(avg(temp),2) as avg_temp,
  round(avg(pressure),2) as avg_pressure,
  round(avg(humidity),2) as avg_humidity,
  round(avg(clouds),2) as avg_clouds
  --,ROW_NUMBER() OVER (PARTITION BY daily_weather order by COUNT(weather) desc) as row_number
  FROM daily_weather
  group by daily_weather, weather
  qualify ROW_NUMBER() OVER (PARTITION BY daily_weather order by COUNT(weather) desc) = 1
)
SELECT * FROM daily_weather_agg