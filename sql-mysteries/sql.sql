SELECT name 
  FROM sqlite_master
where type = 'table'

-- get crime scene report

SELECT description
  FROM crime_scene_report
  WHERE city = 'SQL City'
  AND date = '20180115'
  AND type = 'murder'

-- get both witnesses and transcripts

WITH w1 as (
  SELECT * 
  FROM person
  WHERE address_street_name = 'Northwestern Dr'
  ORDER BY address_number DESC
  LIMIT 1
), w2 as (
  SELECT *
  FROM person
  WHERE address_street_name = 'Franklin Ave'
  AND name LIKE 'Annabel %'
)
SELECT id, name, transcript FROM (
  (
    SELECT * FROM w1
    UNION 
    SELECT * FROM w2
  )
    LEFT JOIN interview
    ON id = interview.person_id
)


-- get suspect that matches both witness reports

WITH check_ins AS (
  SELECT id, check_in_time, check_out_time, person_id, name
  FROM get_fit_now_check_in
  LEFT JOIN get_fit_now_member
  ON get_fit_now_check_in.membership_id = get_fit_now_member.id
  WHERE check_in_date = '20180109'
  AND id LIKE '48Z%'
), licenses AS (
  SELECT id as license_id
  FROM drivers_license
  WHERE plate_number LIKE '%H42W%'
  AND gender = 'male'
), drivers AS (
  SELECT * FROM licenses
  LEFT JOIN person
  ON licenses.license_id = person.license_id
), suspect AS (
  SELECT * FROM check_ins
    JOIN drivers
    ON check_ins.person_id = drivers.id
)
SELECT person_id as id, name FROM suspect

-- submit

INSERT INTO solution VALUES (1, 'Jeremy Bowers');   
SELECT value FROM solution;

-- get suspect's interview

SELECT transcript
  FROM interview
  WHERE person_id = '67318'

-- find killer

WITH licenses AS (
   SELECT id as license_id
  FROM drivers_license
  WHERE hair_color = 'red'
  AND height BETWEEN 65 AND 67
  AND car_make = 'Tesla'
  AND car_model = 'Model S'
 ), drivers AS (
   SELECT id, name
     FROM licenses
     LEFT JOIN person
  ON licenses.license_id = person.license_id
 ), concerts AS (
   SELECT person_id, count(*) as num_attended 
   FROM facebook_event_checkin 
   WHERE event_name = 'SQL Symphony Concert'
   AND date LIKE '201712%'
   GROUP BY person_id
   HAVING num_attended = 3
 )
SELECT id, name FROM concerts
JOIN drivers
ON concerts.person_id = drivers.id

-- submit

INSERT INTO solution VALUES (1, 'Miranda Priestly');
SELECT value FROM solution;