-- 1) Find the capacity of the plane given its registration number.
SELECT M.Capacity
FROM PLANE P
JOIN MODEL M ON P.ModelNo = M.ModelNo
WHERE P.RegNo = 'TC-ABC';

-- 2) Find name of the technicians that are experts for a given model.
SELECT E.Name
FROM TECHNICIAN T
JOIN EMPLOYEES E ON T.SSN = E.SSN
JOIN EXPERT EX ON T.SSN = EX.SSN
WHERE EX.ModelNo = 1;

-- 3) Find FAA test number, name and score of a traffic controller given his name.
-- Note: In the original schema, Name is placed under TECHNICIAN instead of EMPLOYEES.
-- Since TRAFFICCONT and TECHNICIAN both inherit from EMPLOYEES (isa relationship),
-- Name should belong to EMPLOYEES. Query is written assuming Name is in EMPLOYEES.
SELECT TI.FAANo, TE.Name, TI.Score
FROM TRAFFICCONT TC
JOIN EMPLOYEES E ON TC.SSN = E.SSN
JOIN TESTINFO TI ON TC.SSN = TI.SSN
JOIN TEST TE ON TI.FAANo = TE.FAANo
WHERE E.Name = 'John Doe';

-- 4) Find number of technicians work at the airport.
SELECT COUNT(*) AS NumberOfTechnicians
FROM TECHNICIAN T;

-- 5) Find the technician having the highest salary.
SELECT E.Name, T.Salary
FROM TECHNICIAN T
JOIN EMPLOYEES E ON T.SSN = E.SSN
WHERE T.Salary = (SELECT MAX(Salary) FROM TECHNICIAN);

-- 6) For each union find number of employees belong to the union.
SELECT UnionMemNo, COUNT(*) AS NumberOfEmployees
FROM EMPLOYEES
GROUP BY UnionMemNo;





--CUSTOM QUERIES
-- 1) Count and categorize planes by weight
SELECT 
    CASE 
        WHEN M.Weight < 40000 THEN 'Light'
        WHEN M.Weight BETWEEN 40000 AND 100000 THEN 'Medium'
        ELSE 'Heavy'
    END AS WeightCategory,
    COUNT(P.RegNo) AS PlaneCount
FROM PLANE P
JOIN MODEL M ON P.ModelNo = M.ModelNo
GROUP BY WeightCategory
ORDER BY PlaneCount DESC;

-- 2) Find tests where the technician isnt an expert
SELECT TI.RegNo, TI.SSN, E.Name, P.ModelNo AS PlaneModel
FROM TESTINFO TI
JOIN PLANE P ON TI.RegNo = P.RegNo
JOIN EMPLOYEES E ON TI.SSN = E.SSN
LEFT JOIN EXPERT EX ON TI.SSN = EX.SSN AND P.ModelNo = EX.ModelNo
WHERE EX.SSN IS NULL;

-- 3) Total labor hours spent on maintenence by unions
SELECT E.UnionMemNo, SUM(TI.Hours) AS TotalMaintenanceHours
FROM TESTINFO TI
JOIN EMPLOYEES E ON TI.SSN = E.SSN
GROUP BY E.UnionMemNo
ORDER BY TotalMaintenanceHours DESC;

-- 4) Find planes with most maintenence spent
SELECT M.ModelNo, SUM(TI.Hours) AS TotalMaintenanceHours
FROM TESTINFO TI
JOIN PLANE P ON TI.RegNo = P.RegNo
JOIN MODEL M ON P.ModelNo = M.ModelNo
GROUP BY M.ModelNo
ORDER BY TotalMaintenanceHours DESC;

-- 5) Find average test score for each planes
SELECT RegNo, ROUND(AVG(Score), 2) AS AverageScore
FROM TESTINFO
GROUP BY RegNo
ORDER BY AverageScore ASC;

-- 6) Find technicians who are experts on more than one model
SELECT E.Name, COUNT(EX.ModelNo) AS ExpertModelCount
FROM EMPLOYEES E
JOIN TECHNICIAN T ON E.SSN = T.SSN
JOIN EXPERT EX ON T.SSN = EX.SSN
GROUP BY E.SSN, E.Name
HAVING COUNT(EX.ModelNo) > 1;

-- 7) Find airplanes that received a test score below 90
SELECT TI.RegNo, TE.Name AS TestName, TI.Score, TI.Date
FROM TESTINFO TI
JOIN TEST TE ON TI.FAANo = TE.FAANo
WHERE TI.Score < 90
ORDER BY TI.Score ASC;

-- 8) Find the average salary of technicians
SELECT ROUND(AVG(Salary), 2) AS AverageTechnicianSalary
FROM TECHNICIAN;

-- 9) Find each technician and total number of tests performed
SELECT E.Name, COUNT(TI.FAANo) AS NumberOfTestsPerformed
FROM EMPLOYEES E
JOIN TECHNICIAN T ON E.SSN = T.SSN
LEFT JOIN TESTINFO TI ON T.SSN = TI.SSN
GROUP BY E.SSN, E.Name
ORDER BY NumberOfTestsPerformed DESC;

-- 10) Find traffic controllers whose medical exam date is before 2024-06-01
SELECT E.Name, TC.ExamDate
FROM TRAFFICCONT TC
JOIN EMPLOYEES E ON TC.SSN = E.SSN
WHERE TC.ExamDate < '2024-06-01'
ORDER BY TC.ExamDate;
