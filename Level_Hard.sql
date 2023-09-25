--1.Show all of the patients grouped into weight groups.Show the total amount of patients in each weight group.Order the list by the weight group decending.
select count(*) as patients_in_group ,
floor(weight/10)*10 as weight_group
from patients
group by weight_group
order by weight_group desc

--2.Show patient_id, weight, height, isObese from the patients table.
	--Display isObese as a boolean 0 or 1.
	--Obese is defined as weight(kg)/(height(m)2) >= 30.
	--weight is in units kg.
	--height is in units cm.
select patient_id,
weight,
height,
case
	when (weight/power(height/100.00,2)) >= 30 then 1
	else 0
end as "isObese"
from patients

--3.Show patient_id, first_name, last_name, and attending doctor's specialty.Show only the patients who has a diagnosis as 'Dementia' and the doctor's first name is 'Lisa'
select p.patient_id,
p.first_name as patient_first_name,
p.last_name as patient_last_name,
d.specialty as attending_doctor_speciality
from admissions as a 
join patients as p
on a.patient_id=p.patient_id
join doctors as d
on a.attending_doctor_id=d.doctor_id
where a.diagnosis='Epilepsy' and d.first_name='Lisa'

--4.All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.
--The password must be the following, in order:
--1. patient_id
--2. the numerical length of patient's last_name
--3. year of patient's birth_date

select distinct(patient_id),
concat(patient_id,length(last_name),year(birth_date)) 
from admissions natural join patients

--5.Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance.Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. Add up the admission_total cost for each has_insurance group.
select 
case 
 when patient_id%2 <> 0 then 'No' 
 else 'Yes' 
end as "has_insurance",

case
	when patient_id%2 <> 0 then count(patient_id)*50
    else count(patient_id)*10
end as "cost_after_inurance"
	
from patients
group by "has_insurance" 

--6.Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name
SELECT pr.province_name
FROM province_names pr
JOIN patients p 
ON pr.province_id = p.province_id
GROUP BY pr.province_name
having 
SUM(CASE WHEN p.gender = 'M' THEN 1 ELSE 0 END)
  > SUM(CASE WHEN p.gender = 'F' THEN 1 ELSE 0 END);
  
--7.We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
-- First_name contains an 'r' after the first two letters.
-- Identifies their gender as 'F'
--Born in February, May, or December
-- Their weight would be between 60kg and 80kg
-- Their patient_id is an odd number
-- They are from the city 'Kingston'
select * from patients
where first_name like '__r%' 
  and gender = 'F'
  and month(birth_date) in (2, 5, 12)
  and weight between 60 and 80
  and patient_id % 2 = 1
  and city = 'Kingston';
 
 --8.Show the percent of patients that have 'M' as their gender. Round the answer to the nearest hundreth number and in percent form.
select 
concat(round((select count(patient_id) from patients where gender='M')/cast(count(patient_id) as float)*100,2),'%') as percentage
from patients;

--9.For each day display the total amount of admissions on that day. Display the amount changed from the previous date.
SELECT admission_date,
       COUNT(admission_date) AS admission_day,
       COUNT(admission_date) - LAG(COUNT(admission_date)) OVER () AS admission_count_change
FROM admissions
GROUP BY admission_date;

--10.Sort the province names in ascending order in such a way that the province 'Ontario' is always on top.
select province_name from province_names order by province_name='Ontario' DESC,province_name;

--11.We need a breakdown for the total amount of admissions each doctor has started each year. Show the doctor_id, doctor_full_name, specialty, year, total_admissions for that year.
SELECT
  d.doctor_id as doctor_id,
  CONCAT(d.first_name,' ', d.last_name) as doctor_name,
  d.specialty,
  YEAR(a.admission_date) as selected_year,
  COUNT(*) as total_admissions
FROM doctors as d
  LEFT JOIN admissions as a ON d.doctor_id = a.attending_doctor_id
GROUP BY
  doctor_name,
  selected_year
ORDER BY doctor_id, selected_year
