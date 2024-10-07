-- checking for number of null values in all columns

SELECT COUNT(*) - COUNT(ride_id) ride_id,
 COUNT(*) - COUNT(rideable_type) rideable_type,
 COUNT(*) - COUNT(started_at) started_at,
 COUNT(*) - COUNT(ended_at) ended_at,
 COUNT(*) - COUNT(start_station_name) start_station_name,
 COUNT(*) - COUNT(start_station_id) start_station_id,
 COUNT(*) - COUNT(end_station_name) end_station_name,
 COUNT(*) - COUNT(end_station_id) end_station_id,
 COUNT(*) - COUNT(start_lat) start_lat,
 COUNT(*) - COUNT(start_lng) start_lng,
 COUNT(*) - COUNT(end_lat) end_lat,
 COUNT(*) - COUNT(end_lng) end_lng,
 COUNT(*) - COUNT(member_casual) member_casual
FROM `your_project_id.bikes_2023.combined_data`
;


-- I check to see if there are duplicate rides. There are none.

SELECT COUNT(ride_id) - COUNT(DISTINCT ride_id) AS duplicate_rows
FROM `your_project_id.bikes_2023.combined_data`
;


-- ride_id - all have length of 16

SELECT LENGTH(ride_id) AS length_ride_id, COUNT(ride_id) AS no_of_rows
FROM `your_project_id.bikes_2023.combined_data`
GROUP BY length_ride_id
;


--  I check there are 1592 station from start_station_name

SELECT COUNT(DISTINCT start_station_name) AS num_start_station
FROM `your_project_id.bikes_2023.combined_data`
WHERE start_station_name IS NOT NULL
;


-- I check there are 1597 station from end_station_name

SELECT COUNT(DISTINCT end_station_name) AS num_end_station
FROM `your_project_id.bikes_2023.combined_data`
WHERE end_station_name IS NOT NULL;


-- unique 2 values, count of annual member and casual

SELECT DISTINCT member_casual, COUNT(member_casual) AS no_of_trips
FROM `your_project_id.bikes_2023.combined_data`
GROUP BY member_casual
;


-- Rideable_type - 3 unique types of bikes
SELECT rideable_type, COUNT(rideable_type) AS number_of_trips
FROM `your_project_id.bikes_2023.combined_data`
GROUP BY rideable_type
;


-- I created a new table called 'combined_data_cleaned' 
-- in the 'bikes_2023' dataset. It selects relevant columns from the 
-- 'combined_data' table, calculates the trip duration in minutes, 
-- and adds new columns for the day of the week and month, using 
-- CASE statements for better readability. 
-- The query also filters out records with missing station names, 
-- IDs, and coordinates, as well as trips that are either too short 
-- (1 minute or less) or too long (more than 24 hours).
CREATE TABLE `your_project_id.bikes_2023.combined_data_cleaned` AS
SELECT 
    ride_id,
    rideable_type,	
    started_at,	
    CASE EXTRACT(DAYOFWEEK FROM started_at) 
      WHEN 1 THEN 'SUN'
      WHEN 2 THEN 'MON'
      WHEN 3 THEN 'TUES'
      WHEN 4 THEN 'WED'
      WHEN 5 THEN 'THURS'
      WHEN 6 THEN 'FRI'
      WHEN 7 THEN 'SAT'    
    END AS day_of_week,
    ended_at,	
    CASE EXTRACT(MONTH FROM started_at)
      WHEN 1 THEN 'JAN'
      WHEN 2 THEN 'FEB'
      WHEN 3 THEN 'MAR'
      WHEN 4 THEN 'APR'
      WHEN 5 THEN 'MAY'
      WHEN 6 THEN 'JUN'
      WHEN 7 THEN 'JUL'
      WHEN 8 THEN 'AUG'
      WHEN 9 THEN 'SEP'
      WHEN 10 THEN 'OCT'
      WHEN 11 THEN 'NOV'
      WHEN 12 THEN 'DEC'
    END AS month,
    TIMESTAMP_DIFF(TIMESTAMP(ended_at), TIMESTAMP(started_at), MINUTE) AS tripduration,
    start_station_name,	
    end_station_name,	
    start_lat,	
    start_lng,
    end_lat,
    end_lng,
    member_casual
FROM `your_project_id.bikes_2023.combined_data`
WHERE 
    start_station_name IS NOT NULL AND
    end_station_name IS NOT NULL AND
    start_station_id IS NOT NULL AND
    end_station_id IS NOT NULL AND
    end_lat IS NOT NULL AND
    end_lng IS NOT NULL AND
    TIMESTAMP_DIFF(TIMESTAMP(ended_at), TIMESTAMP(started_at), MINUTE) > 1 AND 
    TIMESTAMP_DIFF(TIMESTAMP(ended_at), TIMESTAMP(started_at), MINUTE) < 1440
;


-- I ensured that this new table has no null values.
SELECT 
    COUNTIF(ride_id IS NULL) AS ride_id_nulls,
    COUNTIF(rideable_type IS NULL) AS rideable_type_nulls,
    COUNTIF(started_at IS NULL) AS started_at_nulls,
    COUNTIF(ended_at IS NULL) AS ended_at_nulls,
    COUNTIF(start_station_name IS NULL) AS start_station_name_nulls,
    COUNTIF(end_station_name IS NULL) AS end_station_name_nulls,
    COUNTIF(start_lat IS NULL) AS start_lat_nulls,
    COUNTIF(start_lng IS NULL) AS start_lng_nulls,
    COUNTIF(end_lat IS NULL) AS end_lat_nulls,
    COUNTIF(end_lng IS NULL) AS end_lng_nulls,
    COUNTIF(member_casual IS NULL) AS member_casual_nulls,
    
    -- Count nulls in new columns
    COUNTIF(day_of_week IS NULL) AS day_of_week_nulls,
    COUNTIF(month IS NULL) AS month_nulls,
    COUNTIF(tripduration IS NULL) AS tripduration_nulls
FROM `your_project_id.bikes_2023.combined_data_cleaned`
;

-- I count the number of rows of this new table 'combined_data_cleaned'

SELECT COUNT(*) AS num_of_rows
FROM `your_project_id.bikes_2023.combined_data_cleaned`
;