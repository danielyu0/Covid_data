-- Comparing total deaths to total cases
-- Shows likely hood of death in canada

SELECT location as country, date, total_cases, total_deaths, total_deaths/total_cases as Death_Percentage
FROM CovidDeaths
WHERE location = 'Canada'
ORDER BY date

-- Displays each days accumulated cases and percentage of population infected
-- Ordered Oldest to New

SELECT Location, date, population, total_cases,(total_cases/population)*100 as Percent_Population_Infected
FROM CovidDeaths
WHERE location ='Canada'
ORDER BY date

-- Displaying Top 10 Deaths in each country
-- Ordered by Highest Total Deaths

SELECT TOP 10 location, MAX(CAST(Total_Deaths as int)) AS Total_Deaths
FROM CovidDeaths
GROUP BY location 
ORDER BY Total_Deaths DESC

-- Displaying Infected percentage
-- Ordered by Highest Infected country

SELECT 
	location, 
	MAX(total_cases) AS Total_cases, 
	population, 
	MAX(total_cases)/population*100 as Percent_Country_infected
FROM CovidDeaths
GROUP BY location, population
ORDER BY Percent_Country_infected DESC

-- Displaying the Percentage of Fully Vaccinated people to population for each country and their death counts
-- Ordered by Percentage of Fully Vaccinated

SELECT 
	d.location, 
	CASE 
		WHEN MAX(CAST(v.people_fully_vaccinated as int)) IS NULL then '0'
		ELSE MAX(CAST(v.people_fully_vaccinated as int))
	END AS Fully_Vaccinated,
	d.population, 
	MAX(CAST(v.people_fully_vaccinated as int))/population*100 as Percent_Fully_Vaccinated,
	CASE 
		WHEN MAX(CAST(Total_Deaths as int)) IS NULL then '0'
		ELSE MAX(CAST(Total_Deaths as int))
		END AS Total_Death_Count
FROM CovidDeaths d
JOIN  CovidVaccinations v
	ON d.location = v.location AND
	d.date = v.date
GROUP BY d.location,d.population
ORDER BY Percent_Fully_Vaccinated desc

-- Create table for all countries with 0 deaths

DROP TABLE if exists Death_Free_Country
CREATE TABLE Death_Free_Country(
	location nvarchar(255),
	People_Vaccinated numeric,
	Population numeric,
	Percent_fully_Vaccinated float,
	Total_Deaths numeric
	)

-- Inserting values into table 

INSERT INTO Death_Free_Country
SELECT 
	d.location, 
	CASE 
		WHEN MAX(CAST(v.people_fully_vaccinated as int)) IS NULL then '0'
		ELSE MAX(CAST(v.people_fully_vaccinated as int))
	END AS Fully_Vaccinated,
	d.population, 
	MAX(CAST(v.people_fully_vaccinated as int))/population*100 as Percent_Fully_Vaccinated,
	CASE 
		WHEN MAX(CAST(Total_Deaths as int)) IS NULL then '0'
		ELSE MAX(CAST(Total_Deaths as int))
		END AS Total_Death_Count
FROM CovidDeaths d
JOIN  CovidVaccinations v
	ON d.location = v.location AND
	d.date = v.date
GROUP BY d.location,d.population
HAVING MAX(CAST(Total_Deaths as int)) IS NULL
ORDER BY Percent_Fully_Vaccinated desc

-- Displaying the table With Countrys that have no deaths.
-- Ordered by Percent_fully_Vaccinated

SELECT *
FROM Death_Free_Country
ORDER BY Percent_fully_Vaccinated desc