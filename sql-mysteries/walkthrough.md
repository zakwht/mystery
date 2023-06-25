https://github.com/NUKnightLab/sql-mysteries

**Prompt**

> A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it. You vaguely remember that the crime was a ​murder​ that occurred sometime on ​Jan.15, 2018​ and that it took place in ​SQL City​. Start by retrieving the corresponding crime scene report from the police department’s database.

---

[**Query 1**](/sql-mysteries/sql.sql#L7C1-L11C22) Get the crime scene report

```sql
SELECT description
  FROM crime_scene_report
  WHERE city = 'SQL City'
  AND date = '20180115'
  AND type = 'murder'
```

> Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave".

---

[**Query 2**](/sql-mysteries/sql.sql#L15C1-L35C2) Find witnesses and get report transcripts

```sql
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
```

| id  | name | transcript |
| --- | ---- | ---------- |
| 14887 | Morty Schapiro | I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W". |
| 16371 | Annabel Miller | I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th |

---

[**Query 3**](/sql-mysteries/sql.sql#L40C1-L61C42) Find the suspect that matches witness reports

```sql
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
```

| id    | name          |
| ----- | ------------- |
| 67318 | Jeremy Bowers |

---

**Check solution**

```sql
INSERT INTO solution VALUES (1, 'Jeremy Bowers');   
SELECT value FROM solution;
```

> Congrats, you found the murderer! But wait, there's more... If you think you're up for a challenge, try querying the interview transcript of the murderer to find the real villain behind this crime. If you feel especially confident in your SQL skills, try to complete this final step with no more than 2 queries. Use this same INSERT statement with your new suspect to check your answer.

---

[**Query 4**](/sql-mysteries/sql.sql#L70C1-L72C28) Get the suspect's interview

```sql
SELECT transcript
  FROM interview
  WHERE person_id = '67318'
```

> I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.

---

[**Query 5**](/sql-mysteries/sql.sql#L76C1-L98C35) Find the new susepct

```sql
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
```

| id    | name             |
| ----- | ---------------- |
| 99716 | Miranda Priestly |

---

**Check solution**

```sql
INSERT INTO solution VALUES (1, 'Miranda Priestly');   
SELECT value FROM solution;
```

> Congrats, you found the brains behind the murder! Everyone in SQL City hails you as the greatest SQL detective of all time. Time to break out the champagne!