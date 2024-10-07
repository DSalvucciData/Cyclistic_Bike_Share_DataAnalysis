-- After importing the 12 files as tables, I merged them all into one single table for ease of use.

CREATE TABLE `bikes_2023.combined_data` AS (
  SELECT * 
  FROM `your_project_id.bikes_2023.bikes_2023_01` 
  UNION ALL
  SELECT * 
  FROM `your_project_id.bikes_2023.bikes_2023_02` 
  UNION ALL
  SELECT * 
  FROM `your_project_id.bikes_2023.bikes_2023_03` 
  UNION ALL
  SELECT * 
  FROM `your_project_id.bikes_2023.bikes_2023_04` 
  UNION ALL
  SELECT * 
  FROM `your_project_id.bikes_2023.bikes_2023_05` 
  UNION ALL
  SELECT * 
  FROM `your_project_id.bikes_2023.bikes_2023_06` 
  UNION ALL
  SELECT * 
  FROM `your_project_id.bikes_2023.bikes_2023_07` 
  UNION ALL
  SELECT * 
  FROM `your_project_id.bikes_2023.bikes_2023_08` 
  UNION ALL
  SELECT * 
  FROM `your_project_id.bikes_2023.bikes_2023_09`  
  UNION ALL
  SELECT * 
  FROM `your_project_id.bikes_2023.bikes_2023_10` 
  UNION ALL
  SELECT * 
  FROM `your_project_id.bikes_2023.bikes_2023_11` 
  UNION ALL
  SELECT * 
  FROM `your_project_id.bikes_2023.bikes_2023_12` 
)
;