-- Summary statistics

SELECT 
    -- Descriptive statistics for the tripduration column
    COUNT(tripduration) AS total_trips,
    AVG(tripduration) AS avg_tripduration_minutes,
    MIN(tripduration) AS min_tripduration_minutes,
    MAX(tripduration) AS max_tripduration_minutes,
    STDDEV(tripduration) AS stddev_tripduration_minutes,
    
    -- Descriptive statistics for the start and end stations
    COUNT(DISTINCT start_station_name) AS unique_start_stations,
    COUNT(DISTINCT end_station_name) AS unique_end_stations,
    
    -- Statistics for user types
    COUNTIF(member_casual = 'member') AS total_members,
    COUNTIF(member_casual = 'casual') AS total_casuals,

    -- Distribution of trips by day of the week
    COUNTIF(day_of_week = 'SUN') AS sunday_trips,
    COUNTIF(day_of_week = 'MON') AS monday_trips,
    COUNTIF(day_of_week = 'TUES') AS tuesday_trips,
    COUNTIF(day_of_week = 'WED') AS wednesday_trips,
    COUNTIF(day_of_week = 'THURS') AS thursday_trips,
    COUNTIF(day_of_week = 'FRI') AS friday_trips,
    COUNTIF(day_of_week = 'SAT') AS saturday_trips,

    -- Distribution of trips by month
    COUNTIF(month = 'JAN') AS january_trips,
    COUNTIF(month = 'FEB') AS february_trips,
    COUNTIF(month = 'MAR') AS march_trips,
    COUNTIF(month = 'APR') AS april_trips,
    COUNTIF(month = 'MAY') AS may_trips,
    COUNTIF(month = 'JUN') AS june_trips,
    COUNTIF(month = 'JUL') AS july_trips,
    COUNTIF(month = 'AUG') AS august_trips,
    COUNTIF(month = 'SEP') AS september_trips,
    COUNTIF(month = 'OCT') AS october_trips,
    COUNTIF(month = 'NOV') AS november_trips,
    COUNTIF(month = 'DEC') AS december_trips

FROM `your_project_id.bikes_2023.combined_data_cleaned`
;


-- Summary statistics of trip duration (ride length) for group: anual riders and annual members

SELECT  
  ROUND(AVG(tripduration), 2) AS average_tripduration,       
  STDDEV(tripduration) AS stddev_tripduration_minutes,       
  MIN(tripduration) AS min_tripduration,                     
  MAX(tripduration) AS max_tripduration,                     
    member_casual                                             
FROM 
  `your_project_id.bikes_2023.combined_data_cleaned`
GROUP BY 
  member_casual
;       


-- Median ride length calculation for each group: members and casual riders

WITH percentiles AS (
  -- Select the member category and calculate the approximate median trip duration
  -- APPROX_QUANTILES(tripduration, 2) returns the minimum and median values
  -- OFFSET(1) selects the median (50th percentile)
  SELECT
    member_casual,
    APPROX_QUANTILES(tripduration, 2)[OFFSET(1)] AS median_ride_length
  FROM
    `your_project_id.bikes_2023.combined_data_cleaned`
  -- Group by member category to calculate the approximate median for each group
  GROUP BY
    member_casual
)
-- Select the member category and its corresponding approximate median ride length
SELECT
  member_casual,
  median_ride_length
FROM
  percentiles;
member_casual	median_ride_length
casual;


 -- Number of trips by bike type and user type

SELECT member_casual, rideable_type, COUNT(*) AS total_trips
FROM `your_project_id.bikes_2023.combined_data_cleaned`
GROUP BY member_casual, rideable_type
ORDER BY member_casual, total_trips
;


-- Number of trips by month

SELECT month, member_casual, COUNT(ride_id) AS total_trips
FROM `your_project_id.bikes_2023.combined_data_cleaned`
GROUP BY month, member_casual
ORDER BY member_casual,
         CASE 
            WHEN month = 'JAN' THEN 1
            WHEN month = 'FEB' THEN 2
            WHEN month = 'MAR' THEN 3
            WHEN month = 'APR' THEN 4
            WHEN month = 'MAY' THEN 5
            WHEN month = 'JUN' THEN 6
            WHEN month = 'JUL' THEN 7
            WHEN month = 'AUG' THEN 8
            WHEN month = 'SEP' THEN 9
            WHEN month = 'OCT' THEN 10
            WHEN month = 'NOV' THEN 11
            WHEN month = 'DEC' THEN 12
         END
         ;


-- Number of trips by weekday
SELECT 
  day_of_week, 
  member_casual, 
  COUNT(ride_id) AS total_trips
FROM 
  `your_project_id.bikes_2023.combined_data_cleaned`
GROUP BY  
  day_of_week,
  member_casual
ORDER BY 
  CASE 
    WHEN day_of_week = 'SUN' THEN 1
    WHEN day_of_week = 'MON' THEN 2
    WHEN day_of_week = 'TUES' THEN 3
    WHEN day_of_week = 'WED' THEN 4
    WHEN day_of_week = 'THURS' THEN 5
    WHEN day_of_week = 'FRI' THEN 6
    WHEN day_of_week = 'SAT' THEN 7
  END,
  member_casual
  ;


 -- Median ride lengths by day for annual members  

SELECT
        DISTINCT median_ride_length,
        member_casual,
        day_of_week
FROM 
        (
        SELECT 
                ride_id,
                member_casual,
                day_of_week,
                tripduration,
                PERCENTILE_DISC(tripduration, 0.5 IGNORE NULLS) OVER(PARTITION BY day_of_week) AS  median_ride_length
        FROM 
                `your_project_id.bikes_2023.combined_data_cleaned`
        WHERE
                member_casual = 'member'
        )
ORDER BY 
        median_ride_length DESC
        ; 


-- Median ride lengths by day for casual riders 

SELECT
        DISTINCT median_ride_length,
        member_casual,
        day_of_week
        
FROM 
        (
        SELECT 
                ride_id,
                member_casual,
                day_of_week,
                tripduration,
                PERCENTILE_DISC(tripduration, 0.5 IGNORE NULLS) OVER(PARTITION BY day_of_week) AS  median_ride_length
        FROM 
                `your_project_id.bikes_2023.combined_data_cleaned`
        WHERE
                member_casual = 'casual'
        )
ORDER BY 
        median_ride_length DESC
        ;


-- Median ride lengths by month for casual riders 

SELECT
        DISTINCT median_ride_length,
        member_casual,
        month
FROM 
        (
        SELECT 
                ride_id,
                member_casual,
                month,
                tripduration,
                PERCENTILE_DISC(tripduration, 0.5 IGNORE NULLS) OVER(PARTITION BY month) AS  median_ride_length
        FROM 
                `your_project_id.bikes_2023.combined_data_cleaned`
        WHERE
                member_casual = 'casual'
        )
ORDER BY 
        median_ride_length DESC
        ;


-- Median ride lengths by month for annual members 

SELECT
        DISTINCT median_ride_length,
        member_casual,
        month
FROM 
        (
        SELECT 
                ride_id,
                member_casual,
                month,
                tripduration,
                PERCENTILE_DISC(tripduration, 0.5 IGNORE NULLS) OVER(PARTITION BY month) AS  median_ride_length
        FROM 
                `your_project_id.bikes_2023.combined_data_cleaned`
        WHERE
                member_casual = 'member'
        )
ORDER BY 
        median_ride_length DESC
        ;    


-- Number of trips by hour for casual riders and annual members

 SELECT   
  EXTRACT(HOUR FROM started_at) AS time_of_day, 
  COUNT(*) AS number_of_trips, 
  member_casual
FROM `your_project_id.bikes_2023.combined_data_cleaned`
GROUP BY time_of_day, member_casual
ORDER BY time_of_day ASC, member_casual
;
