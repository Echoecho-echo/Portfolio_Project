--Covid 19 Data Exploration
--Skills Used: Joins, CTE, Converting Data Types, Creating Views, Window Functions, Aggregate Functions, 

SELECT *
FROM CovidDeaths
WHERE continent is not null
ORDER BY 3, 4; --Ordering by Location, Date

--Selecting the starting data
SELECT location, date, total_cases, total_deaths, population
FROM CovidDeaths
WHERE continent is not null;

--Looking at Total Cases vs Total Deaths.
--Likelihood of dying if you contract covid in your location
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage
FROM CovidDeaths
WHERE continent is not null
and location like '%South Africa%'
ORDER BY 1, 2;

--Looking at Total Cases vs Population
--Shows percentage of population that contracted covid
SELECT location, date, total_cases, population, (total_cases/population)*100 as Contraction_percentage
FROM CovidDeaths
WHERE location LIKE '%Afr%'
ORDER BY 1, 2;

--Find country with highest infection rates, compared to population (and how many were not infected)
--Country with highest infections, how much of the population was infected, and how many were not infected
SELECT location, MAX(total_cases) as Highest_Infection_count, population, MAX((total_cases/population)*100) as Contraction_percentage, (population - MAX(total_cases)) AS Not_infected
FROM CovidDeaths
GROUP BY location, population
ORDER BY Contraction_percentage DESC;

-- Findng out how many people have died in country: Countries with highest mortality rate per population
SELECT location, MAX(cast (total_deaths as int)) AS Total_deaths
FROM CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY Total_deaths DESC;

--Breaking things down (total deaths) by continent
SELECT continent, MAX(cast (total_deaths as int)) AS Total_deaths
FROM CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY Total_deaths DESC;

--Total_cases in each continent against population
SELECT continent, MAX(population) AS Total_population, MAX(total_cases) as Covid_cases
FROM CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY continent;

-- Continent and population
SELECT MAX(population) AS Total_population, continent
FROM CovidDeaths
WHERE continent is not null
GROUP BY continent

--Total population and how many have been vaccinated.

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(cast (vac.new_vaccinations as int)) OVER (Partition By dea.location ORDER BY dea.location,
dea.date) as Rolling_vaccined_people
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.date = vac.date
AND dea.location = vac.location
WHERE dea.continent is not null
ORDER BY location, date

--Using CTE to perform calculation on Partition By in previous query

WITH PercentPopulationVaccinated (continent, location, date, population, new_vaccinations, Rolling_vaccined_people)
as 
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(cast (vac.new_vaccinations as int)) OVER (Partition By dea.location ORDER BY dea.location,
dea.date) as Rolling_vaccined_people
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.date = vac.date
AND dea.location = vac.location
WHERE dea.continent is not null
)

SELECT *, (Rolling_vaccined_people/population)*100 as Percent_Rolling_vaccined_people
FROM PercentPopulationVaccinated

--Creating view for visualization!
GO --Signal to the SSMS to clear cache, and begin a fresh, isolated code block.
Create View PercentPopulationVaccinated as 
WITH PopVsVac as 
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(cast (vac.new_vaccinations as int)) OVER (Partition By dea.location ORDER BY dea.location,
dea.date) as Rolling_vaccined_people
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.date = vac.date
AND dea.location = vac.location
WHERE dea.continent is not null
)

SELECT *, (Rolling_vaccined_people/population)*100 as Percent_Rolling_vaccined_people
FROM PopVsVac

