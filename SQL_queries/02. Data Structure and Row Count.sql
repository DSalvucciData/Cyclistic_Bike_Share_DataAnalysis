-- Count the number of rows in our new table (5,719,877 rows)

SELECT
  COUNT(*) AS num_of_rows
FROM
  `your_project_id.bikes_2023.combined_data`
  ;


-- Check the data type of each column.

SELECT column_name, data_type
FROM `your_project_id.bikes_2023`.INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'combined_data'
;

