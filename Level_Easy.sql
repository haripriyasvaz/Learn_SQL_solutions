--1.Show first name, last name, and gender of patients who's gender is 'M'
SELECT first_name,
       last_name,
       gender
FROM patients
WHERE gender = 'M';

--2.Show first name and last name of patients who does not have allergies. (null)
SELECT first_name,
      last_name
FROM patients
WHERE allergies IS NULL

--3.Show first name of patients that start with the letter 'C'
SELECT first_name
FROM patients
WHERE first_name LIKE 'C%';

--4.Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
SELECT first_name, last_name
FROM patients
WHERE weight <= 120
  AND weight >= 100;
  
--5.Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'
UPDATE patients
SET allergies = 'NKA'
WHERE allergies IS NULL;

--6.Show first name and last name concatenated into one column to show their full name.
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM patients;

--7.Show first name, last name, and the full province name of each patient.
SELECT first_name, last_name, province_name patients
NATURAL JOIN province_names

--8.Show how many patients have a birth_date with 2010 as the birth year.
SELECT COUNT(patient_id) 
FROM  patients 
WHERE YEAR(birth_date)=2010;

--9.Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000
SELECT *
FROM patients
WHERE patient_id IN (1, 45, 534, 879, 1000);

--10.Show the first_name, last_name, and height of the patient with the greatest height
SELECT first_name,last_name, height 
FROM patients
ORDER BY  height DESC
LIMIT 1;

--11.Show the total number of admissions
SELECT COUNT(patient_id) AS total_number_of_admissions
FROM admissions;

--12.Show all the columns from admissions where the patient was admitted and discharged on the same day.
SELECT *
FROM admissions
WHERE admission_date = discharge_date;

--13.Show the patient_id and the total number of admission for the patient id 579.
SELECT a.patient_id,
COUNT(a.patient_id) FROM patients as p  
INNER JOIN  admissions AS a 
ON p.patient_id=a.patient_id 
WHERE p.patient_id=579

--14..Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?
SELECT DISTINCT city 
FROM patients 
WHERE province_id='NS';

--15.Write a query to find the first_name, last name and birth date of patients who have height more than 160 and weight more than 70
SELECT first_name, last_name, birth_date
FROM patients
WHERE height > 160
  AND weight > 70;
  
--16.Write a query to find list of patients first_name, last_name, and allergies from Hamilton where allergies are not null
SELECT first_name, last_name, allergies
FROM patients
WHERE city = 'Hamilton'
  AND allergies IS NOT NULL;
  
--17.Based on cities where our patient lives in, write a query to display the list of unique city starting with a vowel (a, e, i, o, u). Show the result order in ascending by city.
SELECT distinct(city) 
FROM patients WHERE 
city like'a%' or 
city like'e%' or 
city like'i%' or 
city like'o%' or 
city like'u%' 
order by city asc
