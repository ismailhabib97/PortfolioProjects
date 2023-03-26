SELECT *
FROM Portfolio_project..CovidDeaths
ORDER BY 3,4

--SELECT *
--FROM Portfolio_project..CovidVaccinations
--ORDER BY 3,4

ALTER TABLE CovidDeaths
ALTER COLUMN total_deaths float;

ALTER TABLE CovidDeaths
ALTER COLUMN total_cases float;

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM Portfolio_project..CovidDeaths
WHERE location = 'Egypt'
ORDER BY 1,2

SELECT location, date, total_cases, population, (total_cases/population)*100 as CasesPerPopulationPercentage
FROM Portfolio_project..CovidDeaths
WHERE location = 'Egypt'
ORDER BY 1,2 

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as CasesPerPopulationPercentage
FROM Portfolio_project..CovidDeaths
--WHERE location = 'Egypt'
GROUP BY location, population
ORDER BY 4 desc

SELECT location, population, MAX(total_deaths) as HighestDeathCount, MAX((total_deaths/population))*100 as DeathPerPopulationPercentage
FROM Portfolio_project..CovidDeaths
--WHERE location = 'Egypt'
GROUP BY location, population
ORDER BY 4 desc

SELECT location, MAX(total_deaths) as HighestDeathCount--, MAX((total_deaths/population))*100 as DeathPerPopulationPercentage
FROM Portfolio_project..CovidDeaths
--WHERE location = 'Egypt'
GROUP BY location, population
ORDER BY 2 desc