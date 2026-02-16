WITH BIKE AS (
    SELECT DISTINCT
        START_STATION_ID AS STATION_ID,
        START_STATION_NAME AS STATION_NAME,
        START_LAT,
        START_LON
    FROM {{ ref('stg_bike') }}
    WHERE RIDE_ID != '"bikeid"' AND RIDE_ID != 'bikeid'
)

SELECT * FROM BIKE
