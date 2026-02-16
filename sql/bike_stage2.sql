CREATE STAGE DEMO.DEMO_SCHEMA.BIKE2;

---
 --snow stage copy "D:/__Snowflake/2018-citibike-tripdata/2018-citibike-tripdata" "@DEMO.DEMO_SCHEMA.bike2" --recursive;

CREATE OR REPLACE TABLE DEMO.DEMO_SCHEMA.BIKE (
    RIDE_ID STRING,
    STARTED_AT STRING,
    ENDED_AT STRING,
    START_STATION_NAME STRING,
    START_STATION_ID STRING,
    END_STATION_NAME STRING,
    END_STATION_ID STRING,
    START_LAT STRING,
    START_LON STRING,
    END_LAT STRING,
    END_LON STRING,
    MEMBER_CSUAL STRING
);

COPY INTO DEMO.DEMO_SCHEMA.BIKE
FROM(
SELECT  
t.$12,
t.$2,
t.$3,
t.$5,
t.$4,
t.$9,
t.$8,
t.$6,
t.$7,
t.$10,
t.$11,
t.$13
FROM @DEMO.DEMO_SCHEMA.BIKE2 t
);



"tripduration"
"starttime"
"stoptime"
"start station id"
"start station name"
"start station latitude"
"start station longitude"
"end station id"
"end station name"
"end station latitude"
"end station longitude"
"bikeid"
"usertype"
"birth year"
"gender"
