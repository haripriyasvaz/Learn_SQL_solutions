--17.Show unique birth years from patients and order them by ascending.
select distinct(year(birth_date)) as yr 
from patients 
order by yr asc

--18.Show unique first names from the patients table which only occurs once in the list. For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. If only 1 person is named 'Leo' then include them in the output.
select distinct(first_name) as p 
from patients 
group by p 
having count(p)=1

--19.Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
select patient_id,first_name from patients 
where first_name like 's%s' and length(first_name)>=6;

--20Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'. Primary diagnosis is stored in the admissions table.
select patient_id,first_name,last_name from patients 
natural join admissions 
where diagnosis='Dementia'

--21.Display every patient's first_name. Order the list by the length of each name and then by alphbetically.
select first_name from patients 
order by length(first_name),first_name asc

--22.Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.
select (select count(patient_id)  from patients where gender='M') as male_patients,
(select count(patient_id) from patients where gender='F') as female_patients

--23.Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name.
select first_name,last_name,allergies from patients 
where  allergies= 'Penicillin' or allergies='Morphine' 
order by allergies ASC, first_name,last_name

--24.Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
select patient_id,diagnosis from admissions 
group by patient_id,diagnosis 
having count(diagnosis)>1

--25.Show the city and the total number of patients in the city.Order from most to least patients and then by city name ascending.
select city, count(patient_id) as num_patients from patients
group by City  
order by num_patients desc, City ASC

--26.Show first name, last name and role of every person that is either patient or doctor.The roles are either "Patient" or "Doctor".
select first_name,last_name , 'Patient' as role from patients 
union all 
select first_name,last_name ,'dOCTOR' as role from doctors

--27.Show all allergies ordered by popularity. Remove 'NKA' and NULL values from query.
select distinct(allergies) ,count(patient_id) as total_diagnosis 
from patients
where allergies is not null 
group by allergies 
order by count(*) desc

--28.Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
select first_name,last_name,birth_date from patients 
where year(birth_date) >=1970 and year(birth_date)< 1980 
order by birth_date

--29.We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma.Order the list by the first_name in decending orderEX: SMITH,jane
select concat(upper(last_name),',',Lower(first_name)) as new_name_format 
from patients 
order by first_name desc

--30.Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
select distinct(province_id) ,
sum(height) from patients 
group by province_id 
having sum(height)>7000

--31.Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
select (max(weight)-min(weight)) 
from patients 
where last_name='Maroni'

--32.Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
select day(admission_date) as day_number,
count(admission_date) as number_of_admissions  
FROM admissions 
group by day(admission_date) 
order by number_of_admissions DESC

--33.Show the all columns for patient_id 542's most recent admission_date.
select * from admissions 
where patient_id=542 
order by admission_date 
desc limit 1

--34.Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
  --1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
  --2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.
select patient_id,attending_doctor_id,diagnosis 
from admissions 
where (mod(patient_id,2)<>0 and attending_doctor_id in (1,5,19)) 
or (attending_doctor_id like '%2%' 
and length(patient_id) = 3)

--35.Show first_name, last_name, and the total number of admissions attended for each doctor.Every admission has been attended by a doctor.
select d.first_name,d.last_name,count(a.attending_doctor_id) from doctors as d 
inner join admissions as a 
where d.doctor_id=a.attending_doctor_id
group by attending_doctor_id

--36.For each doctor, display their id, full name, and the first and last admission date they attended.
select doctor_id, concat(first_name,' ',last_name)  as full_name ,
min(admission_date),
max(admission_date) 
from admissions as a 
join doctors as d 
on a.attending_doctor_id=d.doctor_id 
group by full_name 
order by doctor_id

--37.Display the total amount of patients for each province. Order by descending.
select province_name,
count(patient_id) as patient_count
from patients
natural join province_names 
group by province_name 
order by patient_count desc

--38.For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.
select concat(p.first_name,' ',p.last_name) as patient_name,
a.diagnosis,
concat(d.first_name,' ',d.last_name) as doctor_name
from admissions as a
join patients as p
on a.patient_id=p.patient_id
join doctors as d
on a.attending_doctor_id=d.doctor_id

--39.display the number of duplicate patients based on their first name and last name.
select first_name,last_name,
count(*) as no_of_duplicates from patients 
group by first_name,last_name
having count(*)>1

--40.Display patient's full name,
	-----height in the unit feet rounded to 1 decimal,
	-----weight in the unit pounds rounded to 0 decimals,
	-----birth_date,
	-----gender non abbreviated.
	-----Convert CM to feet by dividing by 30.48.
	-----Convert KG to pounds by multiplying by 2.205.
select concat(first_name,' ',last_name) as patient_name,
round(height/30.48,1) as 'height"feet"',
round(weight*2.205,0) as  'weight"pounds"',
birth_date,
"MALE" as gender_type
from patients
where gender='M'

UNION all

select concat(first_name,' ',last_name) as patient_name,
round(height/30.48,1) as 'height"feet"',
round(weight*2.205,0) as  'weight"pounds"',
birth_date,
"FEMALE" as gender_type
from patients
where gender='F'

--41.Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. (Their patient_id does not exist in any admissions.patient_id rows.)
SELECT p.patient_id ,
first_name,
  last_name
  FROM patients as p 
LEFT join admissions as a 
on p.patient_id=a.patient_id
where a.patient_id is NULL

