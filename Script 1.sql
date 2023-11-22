
/***********************************************************************************
************************************************************************************
	CREATING DATABASE AND TABLES
************************************************************************************
***********************************************************************************/
DROP DATABASE IF EXISTS petHospital;

CREATE DATABASE IF NOT EXISTS petHospital;
USE petHospital;

CREATE TABLE IF NOT EXISTS vet
( 
	vetID INT, 
	fName VARCHAR(15), 
    lName VARCHAR(15), 
    salary DOUBLE(10,2), 
    seniority VARCHAR(15), 
    supervisor INT,
 	PRIMARY KEY (vetID),
	CONSTRAINT FK_SUPERVISOR FOREIGN KEY(supervisor) 
	REFERENCES Vet(vetID)
	ON UPDATE CASCADE 
    ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS emergencyContact
( 
    vetID INT,
    fName VARCHAR(15),
    phoneNumber INT,
    relationship VARCHAR(50),
	PRIMARY KEY(vetID, fName),
	CONSTRAINT FK_EC_VETID FOREIGN KEY(vetID) 
	REFERENCES Vet(vetID)
	ON UPDATE CASCADE 
    ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS client
( 
	ClientID INT,
	fName VARCHAR(15),
    lName VARCHAR(15),
	street VARCHAR(30),
    town VARCHAR(30),
    county VARCHAR(30),
    postcode VARCHAR(7),
    phoneNumber INT,
    emailAddress VARCHAR(50),
	PRIMARY KEY(ClientID)
);

CREATE TABLE IF NOT EXISTS pet
( 
	microchipNumber CHAR(16), 
    petName VARCHAR(15), 
    gender CHAR(1), 
    insuranceDetails VARCHAR(100), 
    dateOfBirth DATE, 
    weight DOUBLE(6,2), 
    ClientID INT, 
	PRIMARY KEY(microchipNumber),
	CONSTRAINT FK_PET_CLIENTID FOREIGN KEY(ClientID) 
	REFERENCES Client(ClientID)
	ON UPDATE CASCADE 
    ON DELETE NO ACTION
);


CREATE TABLE IF NOT EXISTS appointment
( 
	visitID INT AUTO_INCREMENT, 
    visitDate DATE, 
    clinicalNotes TEXT, 
    diagnosis VARCHAR(500), 
    microchipNumber CHAR(16),
	PRIMARY KEY(visitID),
	CONSTRAINT FK_APT_MCNUMBER FOREIGN KEY(microchipNumber) 
	REFERENCES Pet(microchipNumber)
	ON UPDATE CASCADE 
    ON DELETE NO ACTION
);


CREATE TABLE IF NOT EXISTS cat
( 
	microchipNumber CHAR(16),
    irishFelineSocietyID VARCHAR(9),
    litterBoxTrained VARCHAR(3),
	PRIMARY KEY(microchipNumber),
	CONSTRAINT FK_CAT_MCNUMBER FOREIGN KEY(microchipNumber) 
	REFERENCES Pet(microchipNumber)
	ON UPDATE CASCADE 
    ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS dog
( 
	microchipNumber	CHAR(16),
    kennelClubRegistrationNumber INT,
    needsMuzzle	VARCHAR(3),
    numberOfDailyWalks INT, 
    breed VARCHAR(25),
 	PRIMARY KEY(microchipNumber),
	CONSTRAINT FK_DOG_MCNUMBER FOREIGN KEY(microchipNumber) 
	REFERENCES Pet(microchipNumber)
	ON UPDATE CASCADE 
    ON DELETE NO ACTION
);


CREATE TABLE IF NOT EXISTS medicine
( 
	medicineID VARCHAR(8),
	name VARCHAR(50),
    activeIngredient VARCHAR(50),
    dosage VARCHAR(30),
    price DOUBLE(10,2),
	PRIMARY KEY(medicineID)
);


CREATE TABLE IF NOT EXISTS examines
( 
	vetID INT,
	visitID INT,
	PRIMARY KEY(vetID, visitID),
	CONSTRAINT FK_EXAMINES_VISITID FOREIGN KEY(visitID) 
	REFERENCES appointment(visitID)
	ON UPDATE CASCADE ON DELETE NO ACTION,
    CONSTRAINT FK_EXAMINES_VETID FOREIGN KEY(vetID) 
	REFERENCES Vet(vetID)
	ON UPDATE CASCADE 
    ON DELETE NO ACTION
);


CREATE TABLE IF NOT EXISTS prescribes
( 
	visitID INT,
    medicineID VARCHAR(8),
    quantity VARCHAR(30),
	PRIMARY KEY(visitID, medicineID),
	CONSTRAINT FK_PRESCRIBES_VISITID FOREIGN KEY(visitID) 
	REFERENCES appointment(visitID)
	ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT FK_PRESCRIBES_MEDID FOREIGN KEY(medicineID) 
	REFERENCES medicine(medicineID)
	ON UPDATE CASCADE 
    ON DELETE NO ACTION
);



/***********************************************************************************
************************************************************************************
	INSERTING DATA
************************************************************************************
***********************************************************************************/

INSERT INTO vet (vetID, fName, lName, salary, seniority, supervisor) VALUES
(101,' Anna', 'Walsh', 85000, 'Senior', null),
(102,' Pat', 'Beresford', 65000, 'Junior', 101),
(103,' Nicola', 'McGrath', 95000, 'Senior', null),
(104,' Fiona', 'Hand', 72000, 'Junior', 103),
(105,' Niamh', 'Moloney', 61000, 'Junior', 101),
(106,' Chris', 'Reilly', 83500, 'Senior', null),
(107,' Emma', 'Daly', 59000, 'Junior', 106),
(108,' Catherine', 'Whelan', 65250, 'Junior', 106),
(109,' John', 'Lydon', 75100, 'Junior', 103);



INSERT INTO emergencyContact (vetID, fName, phoneNumber, relationship) VALUES
(102,' Linda', 0896452334, 'Wife'),
(102,' Jack', 0896589973, 'Brother'),
(103,' James', 0881648954, 'Dad'),
(104,' Sarah', 0872635451, 'Wife'),
(104,' Emer', 0876945315, 'Sister'),
(105,' Sheila', 0865422134, 'Mam'),
(106,' Sarah', 0865945635, 'Sister'),
(107,' Jim', 0876498754, 'Brother'),
(108,' Austin', 0869782156, 'Husband'),
(108,' Mike', 0896486454, 'Brother'),
(109,' Harry', 0896458543, 'Husband');



INSERT INTO client (ClientID, fName, lName, street, town, county, postcode, phoneNumber, emailAddress) VALUES
(21487,' Anna', 'Begley', '14 Gilabbey st', 'Cork', 'Cork', 'hf7dj58', 0871654859, 'Anna.Begley@gmail.com'),
(21947,' Bernard', 'Walsh', '59 Sallybrook', 'Dungarvan', 'Waterford', 'fj5h833', 0895654689, 'Bernard.Walsh@gmail.com'),
(25498,' James', 'Harty', 'Example Drive', 'Youghal', 'Cork', 'f747bh4', 0896589973, 'James.Harty@gmail.com'),
(24935,' Sarah', 'Campbell', '46 Seaview', 'Clonea', 'Waterford', 'j435j45', 0881648954, 'Sarah.Campbell@gmail.com'),
(54852,' Michael', 'Power', '38 Autumn Drive', 'Midleton', 'Cork', 'j454356', 0872689451, 'Michael.Power@gmail.com'),
(95421,' Chris', 'McGrath', 'Ballinamuck', 'Clonmel', 'Tipperary', 'jj534js', 0876935315, 'Chris.McGrath@gmail.com'),
(78452,' Pauline', 'Heffernan', '32 Springmeadows', 'Dungarvan', 'Waterford', 'ri83423', 0865422137, 'Pauline.Heffernan@gmail.com'),
(63846,' Jack', 'McgGrath', '15 Urseline Court', 'Waterford', 'Waterford', 'f7284j4', 0876458953, 'Jack.McgGrath@gmail.com'),
(80921,' Aileen', 'Crotty', 'Ballinatray', 'Tramore', 'Waterford', 'd834757', 0895454550, 'Aileen.Crotty@gmail.com'),
(87384,' Mike', 'Sheehy', '15 Johns Terrace', 'Clonmel', 'Tipperary', 'hfjh876', 0875469228, 'Mike.Sheehy@gmail.com');


INSERT INTO pet (microchipNumber, petName, gender, insuranceDetails, dateOfBirth, weight, clientID) VALUES
('IE83483760377721',' Prancer', 'M', 'Not Insured', '2022-11-5', 29.1, 21487),
('IE59463285469875',' Razzle', 'F', 'Not Insured', '2018-1-19', 35, 21947),
('IE83749732847293',' Millie', 'M', 'Aviva policy number 3489573', '2016-7-19', 65, 25498),
('IE83749237943284',' Fluff', 'F', 'Not Insured', '2022-2-13', 9, 24935),
('IE93487932743988',' Sunny', 'F', 'Not Insured', '2014-7-13', 45.8, 21487),
('IE78364873264823',' Jack', 'M', 'Aviva policy number 9834759347', '2021-4-5', 16.7, 25498),
('IE78364823649348',' Muffles', 'F', 'Allianz Policy 38743', '2018-9-4', 32.1, 54852),
('IE78346823783487',' Rocky', 'M', 'Not Insured', '2022-6-4', 15.3, 95421),
('IE83747923893429',' Maisey', 'F', 'Not Insured', '2023-2-16', 21.3, 78452),
('IE87364823340293',' Fluff', 'F', 'Allianz Policy 54555', '2019-7-1', 18.7, 21487),
('IE73284632846238',' Blacky', 'M', 'Not Insured', '2022-9-4', 4, 63846),
('IE83247892374983',' Tiger', 'M', 'Not Insured', '2022-5-1', 3.7, 21487),
('IE93274923749324',' Sam', 'F', 'Not Insured', '2018-12-5', 4.3, 80921),
('IE83927549382759',' Lady', 'F', 'Allianz Policy 465937', '2017-11-19', 5, 87384),
('IE98374932749323',' Milo', 'M', 'Not Insured', '2017-6-1', 4.6, 21487),
('IE93749327497234',' Poppy', 'F', 'Not Insured', '2023-5-1', 2.1, 25498);




INSERT INTO appointment (visitID, visitDate, clinicalNotes, diagnosis, microchipNumber) VALUES
(1, '2023-5-17', 'Up-to-date on previous vaccinations. No known allergies or adverse reactions to vaccines. Alert and responsive. No signs of illness. Healthy weight. Normal body condition.', 'Routine vaccination due.', 'IE83483760377721'),
(2, '2023-6-1', 'Recurrent eye irritation and tearing due to bilateral lower eyelid entropion. No previous eye surgeries. Mild conjunctival redness. Bilateral lower eyelid entropion affecting both eyes.', 'Bilateral lower eyelid entropion requiring surgical correction to alleviate eye irritation.', 'IE59463285469875'),
(3, '2023-8-2', 'No prior medical issues. No signs of aggression or spraying. Indoor animal. Healthy body condition. No abnormalities noted on general examination.', 'Routine neuter procedure.', 'IE83483760377721'),
(4, '2023-8-3', 'Up-to-date on previous vaccinations. No known allergies or adverse reactions to vaccines. Alert and responsive. No signs of illness. Healthy weight. Normal body condition.', 'Routine vaccination due.', 'IE93487932743988'),
(5, '2023-9-5', 'No prior medical issues. No signs of aggression or spraying. Indoor animal. Healthy body condition. No abnormalities noted on general examination.', 'Routine neuter procedure.', 'IE93487932743988'),
(6, '2023-9-6', 'Up-to-date on previous vaccinations. No known allergies or adverse reactions to vaccines. Alert and responsive. No signs of illness. Healthy weight. Normal body condition.', 'Routine vaccination due.', 'IE78346823783487'),
(7, '2023-9-15', 'No prior medical issues. No signs of aggression or spraying. Indoor animal. Healthy body condition. No abnormalities noted on general examination.', 'Routine neuter procedure.', 'IE83747923893429'),
(8, '2023-9-15', 'No prior medical issues. No signs of aggression or spraying. Indoor animal. Healthy body condition. No abnormalities noted on general examination.', 'Routine neuter procedure.', 'IE93274923749324'),
(9, '2023-9-30', 'Owner reports sudden onset of limping after playing fetch. No known trauma or injury observed. Weight-bearing lameness on right hind limb. Mild swelling and warmth around the stifle joint. Full range of motion, no audible joint pops. No obvious wounds or foreign objects in paw pads.', 'Acute lameness - likely musculoskeletal injury, possible strain or sprain.', 'IE83927549382759'),
(10, '2023-10-1', 'Up-to-date on previous vaccinations. No known allergies or adverse reactions to vaccines. Alert and responsive. No signs of illness. Healthy weight. Normal body condition.', 'Routine vaccination due.', 'IE98374932749323'),
(11, '2023-10-17', 'Owner reports sudden onset of limping after playing fetch. No known trauma or injury observed. Weight-bearing lameness on right hind limb. Mild swelling and warmth around the stifle joint. Full range of motion, no audible joint pops. No obvious wounds or foreign objects in paw pads.', 'Acute lameness - likely musculoskeletal injury, possible strain or sprain.', 'IE83747923893429'),
(12, '2023-10-18', 'Owner reports sudden onset of limping after playing fetch. No known trauma or injury observed. Weight-bearing lameness on right hind limb. Mild swelling and warmth around the stifle joint. Full range of motion, no audible joint pops. No obvious wounds or foreign objects in paw pads.', 'Acute lameness - likely musculoskeletal injury, possible strain or sprain.', 'IE93487932743988'),
(13, '2023-11-1', 'Owner reports sudden onset of limping after playing fetch. No known trauma or injury observed. Weight-bearing lameness on right hind limb. Mild swelling and warmth around the stifle joint. Full range of motion, no audible joint pops. No obvious wounds or foreign objects in paw pads.', 'Acute lameness - likely musculoskeletal injury, possible strain or sprain.', 'IE98374932749323');


INSERT INTO cat (microchipNumber, irishFelineSocietyID, litterBoxTrained) VALUES
('IE73284632846238','GEI873766', 'Yes'),
('IE83247892374983',null, 'No'),
('IE93274923749324','GEI837500', 'No'),
('IE83927549382759',null, 'Yes'),
('IE98374932749323',null, 'Yes'),
('IE93749327497234','GEI384392', 'No');


INSERT INTO dog (microchipNumber, kennelClubRegistrationNumber, needsMuzzle, numberOfDailyWalks, breed) VALUES
('IE83483760377721', null, 'No', 1, 'German sheperd'),
('IE59463285469875', 15975, 'Yes', 3, 'Pitbull'),
('IE83749732847293', null, 'No', 0, 'German sheperd'),
('IE83749237943284', 37287, 'No', 1, 'Collie'),
('IE93487932743988', 83283, 'No', 2, 'Irish Wolfhound'),
('IE78364873264823', null, 'Yes', 0, 'Pitbull'),
('IE78364823649348', null, 'No', 2, 'Golden Labrador'),
('IE78346823783487', 89342, 'No', 0, 'Cocker Spaniel'),
('IE83747923893429', 65455, 'No', 1, 'German sheperd'),
('IE87364823340293', null, 'Yes', 2, 'Rottweiler');


INSERT INTO medicine (medicineID, name, activeIngredient, dosage, price) VALUES
('MED59631', 'Leptospirosis vaccine', 'Leptospirosis…', '1 vial', 12.55),
('MED98566', 'General anesthesia', 'analgesic ', '1 mg per 10kg', 37.49),
('MED46685', 'DERAMAXX', 'Deracoxib', '5mg', 6.71),
('MED65287', 'Metacam', 'Moloxidel', '400mg', 12.75);


INSERT INTO examines (vetID, visitID) VALUES
(102, 1),
(102, 2),
(107, 3),
(101, 4),
(106, 5),
(107, 6),
(108, 7),
(101, 7),
(109, 7),
(104, 8),
(109, 9),
(109, 10),
(105, 11),
(106, 11),
(104, 12),
(102, 12),
(106, 13);




INSERT INTO prescribes (visitID, medicineID, quantity) VALUES
(2,'MED59631', '1 vial'),
(3,'MED98566', '3.5mg'),
(3,'MED46685', '10 mg'),
(4,'MED98566', '1 vial'),
(5,'MED46685', '3.5mg'),
(5,'MED65287', '10 mg'),
(7,'MED59631', '1 vial'),
(8,'MED59631', '3.5mg'),
(8,'MED98566', '10 mg'),
(10,'MED65287', '1 vial'),
(11,'MED98566', '3.5mg'),
(11,'MED46685', '10 mg'),
(13,'MED65287', '3.5mg');

COMMIT;



/***********************************************************************************
************************************************************************************
	CREATING INDEXES
************************************************************************************
***********************************************************************************/

CREATE INDEX lastnameind ON client(lName);
CREATE INDEX visitDateInd ON appointment(visitDate);
CREATE INDEX medNameInd ON medicine(name);



/***********************************************************************************
************************************************************************************
	CREATING TRIGGERS
************************************************************************************
***********************************************************************************/


CREATE TABLE client_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ClientID INT not null,
	street VARCHAR(30),
    town VARCHAR(30),
    county VARCHAR(30),
    postcode VARCHAR(7),
    phoneNumber INT,
    emailAddress VARCHAR(50),
    changedate DATETIME DEFAULT NULL,
    action VARCHAR(50) DEFAULT NULL
);

DELIMITER $$
CREATE TRIGGER before_client_update 
    BEFORE UPDATE ON client
    FOR EACH ROW 
BEGIN
    INSERT INTO client_audit
    SET action = 'update',
        ClientID = OLD.ClientID,
	    street = OLD.street,
        town = OLD.town,
        county = OLD.county,
        postcode = OLD.postcode,
        phoneNumber = OLD.phoneNumber,
        emailAddress = OLD.emailAddress,
        changedate = NOW(); 
END $$
DELIMITER ;
;


-- Test out the trigger
UPDATE client SET emailaddress = 'updated@email.com'
WHERE clientID = 95421;

SELECT * FROM client_audit;


/***********************************************************************************
************************************************************************************
	CREATING VIEWS
************************************************************************************
***********************************************************************************/

-- Create a view to show clients with pet details. This shows two joins, as well as a sub query with a Union. This is a commonly used query so has been set up as a view
CREATE OR REPLACE VIEW clientWithPetDetails AS
SELECT c.ClientID
, c.fName
, c.lName
, p.petName
, p.microchipNumber
, a.animalType
FROM client c
LEFT JOIN pet p ON c.ClientID = p.ClientID
LEFT JOIN ( SELECT microchipNumber, 'DOG' as AnimalType FROM dog UNION ALL SELECT microchipNumber, 'CAT' as AnimalType FROM CAT) a ON p.microchipNumber = a.microchipNumber;

-- Create a view to only non sensitive information about Vets. Salary, Seniority and Supervisor are all hidden
CREATE OR REPLACE VIEW vetLtd AS
SELECT vetID
, fName
, lName
FROM vet;

-- Create view to show all appointments that happened within the last 90 days. Everytime this view is ran it will contain up to date information
CREATE OR REPLACE VIEW appointmentsLast90Days AS
SELECT *
FROM appointment
WHERE DATEDIFF(CURDATE(),visitDate) < 90;



/***********************************************************************************
************************************************************************************
	CREATING USERS
************************************************************************************
***********************************************************************************/
DROP USER IF EXISTS HospitalOwner;
CREATE USER HospitalOwner IDENTIFIED BY 'secret1'; 
GRANT ALL ON pethospital.* TO HospitalOwner WITH GRANT OPTION;
 
 
 -- create a vet login. Grant select on all tables except for vet and emergencyContact. Grant permission for the vetLtd view above, to hide sentive information
DROP USER IF EXISTS VetLogin;
CREATE USER VetLogin IDENTIFIED BY 'secret2';
GRANT SELECT ON pethospital.appointment TO VetLogin;
GRANT SELECT ON pethospital.cat TO VetLogin;
GRANT SELECT ON pethospital.client TO VetLogin;
GRANT SELECT ON pethospital.dog TO VetLogin;
GRANT SELECT ON pethospital.examines TO VetLogin;
GRANT SELECT ON pethospital.medicine TO VetLogin;
GRANT SELECT ON pethospital.pet TO VetLogin;
GRANT SELECT ON pethospital.prescribes TO VetLogin;
GRANT SELECT ON pethospital.vetLtd TO VetLogin;
GRANT SELECT ON pethospital.appointmentsLast90Days TO VetLogin;


/***********************************************************************************
************************************************************************************
    Test out permissions of users
    run this as VetLogin
************************************************************************************
***********************************************************************************/

-- This should be denied as we don't want vets seeing salary information of other vets
SELECT * FROM vet;

-- This should be denied as vets don't have access to insert any information to the database
INSERT INTO appointment (visitID, visitDate, clinicalNotes, diagnosis, microchipNumber) VALUES
(101, '2023-5-17', 'Up-to-date on previous vaccinations. No known allergies or adverse reactions to vaccines. Alert and responsive. No signs of illness. Healthy weight. Normal body condition.', 'Routine vaccination due.', 'IE83483760377721');


-- VetLogin should have access to this view which shows certain columns from the Vet table (excel salary etc)
SELECT * FROM vetLtd;
