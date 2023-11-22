/***********************************************************************************

WHERE….IN						Query 3
WHERE….BETWEEN					Query 11
WHERE….LIKE						Query 1
Date functions					Query 5, 9, 10
Aggregate functions				Query 3, 8
GROUP BY						Query 3, 8
GROUP BY…HAVING					Query 4, 10
ORDER BY						Query 2, 4, 6, 11
multi-table JOINs				Query 3, 6, 7, 8
OUTER JOINs						Query 3, 6, 7, 8
sub-queries						Query 7, 8
***********************************************************************************/


USE petHospital;



/***********************************************************************************
************************************************************************************
	QUERY 1
    shows all clients where the last name starts with 'C'. lName has an index 
    which makes this query more efficient
************************************************************************************
***********************************************************************************/

SELECT * FROM client
where lName like 'C%';


/***********************************************************************************
************************************************************************************
	QUERY 2
    Count the number of dogs on file for each breed, and order A-Z
************************************************************************************
***********************************************************************************/

SELECT breed
, count(*) as TotalDogs
FROM dog
GROUP BY Breed
ORDER BY Breed ASC;


/***********************************************************************************
************************************************************************************
	QUERY 3
    count the number of times DEAMAXX or Metacam were presribed by each vet
************************************************************************************
***********************************************************************************/

SELECT v.vetID
, m.name as MedicineName
, count(a.visitID) as NoTimesPrescribed
FROM medicine m
LEFT JOIN prescribes p ON m.medicineID = p.MedicineID
LEFT JOIN appointment a ON p.visitID = a.visitID
LEFT JOIN examines e ON e.visitID = a.visitID
LEFT JOIN vet v ON v.vetID = e.vetID
WHERE m.name in ('Metacam', 'DERAMAXX')
GROUP BY v.vetID, m.name ;


/***********************************************************************************
************************************************************************************
	QUERY 4
    Find clients with multiple pets
************************************************************************************
***********************************************************************************/

SELECT ClientID, COUNT(*)
FROM clientWithPetDetails -- this is a view
GROUP BY ClientID
HAVING COUNT(*) >1
ORDER BY COUNT(*) DESC;


/***********************************************************************************
************************************************************************************
	QUERY 5
    Find age of animals in years
************************************************************************************
***********************************************************************************/

SELECT *
, TIMESTAMPDIFF(YEAR, dateOfBirth, CURDATE()) AS ageYears
FROM pet;


/***********************************************************************************
************************************************************************************
	QUERY 6
    show all pets that attended in the last 90 days, and group and show the 
    number of times they attended
************************************************************************************
***********************************************************************************/

SELECT 
p.MicrochipNumber
, p.petName
, CASE WHEN c.MicrochipNumber IS NOT NULL THEN 'Cat'
	WHEN d.MicrochipNumber IS NOT NULL THEN 'Dog'
    ELSE 'UNKNOWN'
    END AS AnimalType
, COUNT(a.VisitID) NumberOfVisits
FROM pet p  
LEFT JOIN cat c on c.microchipNumber = p.MicrochipNumber
LEFT JOIN dog d on d.MicrochipNumber = p.MicrochipNumber
INNER JOIN appointmentsLast90Days a on a.MicrochipNumber = p.microchipNumber
GROUP BY MicrochipNumber, p.petName
	, CASE WHEN c.MicrochipNumber IS NOT NULL THEN 'Cat'
		WHEN d.MicrochipNumber IS NOT NULL THEN 'Dog'
		ELSE 'UNKNOWN'
		END
ORDER BY COUNT(a.VisitID) DESC, p.petName;


/***********************************************************************************
************************************************************************************
	QUERY 7
    This query also exists as a view 'clientWithPetDetails'
************************************************************************************
***********************************************************************************/
SELECT c.ClientID
, c.fName
, c.lName
, p.petName
, p.microchipNumber
, a.animalType
FROM client c
LEFT JOIN pet p ON c.ClientID = p.ClientID
LEFT JOIN ( SELECT microchipNumber, 'DOG' as AnimalType FROM dog UNION ALL SELECT microchipNumber, 'CAT' as AnimalType FROM CAT) a ON p.microchipNumber = a.microchipNumber;


/***********************************************************************************
************************************************************************************
	QUERY 8
    This query joins all client/pet details with the appointments and medicines 
    they prescribed. That is then used as a sub query  to get the average cost 
    of medicines for dogs and cats (regardless of how many visits they have had)
************************************************************************************
***********************************************************************************/

SELECT animalType
, AVG(Cost) AS AverageCostOfMeds
FROM (
		SELECT c.microchipNumber
		, c.animalType
        , SUM(IFNULL(m.price, 0)) as Cost
		FROM clientWithPetDetails c
		LEFT JOIN appointment a ON a.MicrochipNumber = c.MicrochipNumber
		LEFT JOIN prescribes p ON p.visitID = a.visitID
		LEFT JOIN medicine m on p.medicineId = m.medicineID
		GROUP BY microchipNumber, c.animalType ) sub
GROUP BY animalType;


/***********************************************************************************
************************************************************************************
	QUERY 9
    This query also exists as a view 'appointmentsLast90Days'
************************************************************************************
***********************************************************************************/

SELECT *
FROM appointment
WHERE DATEDIFF(CURDATE(),visitDate) < 90;


/***********************************************************************************
************************************************************************************
	QUERY 10
    Find each pet (along with clientID) that have had their first visit to the 
    pet hospital in September
************************************************************************************
***********************************************************************************/

SELECT ClientID
, petName
, min(visitDate) as firstVisit
FROM clientWithPetDetails c
INNER JOIN appointment a ON a.MicrochipNumber = c.MicrochipNumber
GROUP BY ClientID, petName
HAVING MONTH(min(visitDate)) = 9;



/***********************************************************************************
************************************************************************************
	QUERY 11
    Find all pets that visited the petHospital between two dates
************************************************************************************
***********************************************************************************/

SELECT ClientID
, petName
, visitDate
FROM clientWithPetDetails c
INNER JOIN appointment a ON a.MicrochipNumber = c.MicrochipNumber
WHERE visitDate BETWEEN '2023-09-07' and '2023-10-31'
ORDER BY VIsitDate
