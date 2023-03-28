SELECT *
FROM Portfolio_project..CovidDeaths
ORDER BY 3,4

SELECT *
FROM Portfolio_project..CovidVaccinations
ORDER BY 3,4

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

SELECT location, population, MAX(total_deaths) as TotalDeathCount, MAX((total_deaths/population))*100 as DeathPerPopulationPercentage
FROM Portfolio_project..CovidDeaths
--WHERE location = 'Egypt'
GROUP BY location, population
ORDER BY 4 desc

SELECT location, MAX(total_deaths) as TotalDeathCount--, MAX((total_deaths/population))*100 as DeathPerPopulationPercentage
FROM Portfolio_project..CovidDeaths
--WHERE location = 'Egypt'
WHERE continent is  null
GROUP BY location, population
ORDER BY 2 desc

SELECT continent, MAX(total_deaths) as TotalDeathCount--, MAX((total_deaths/population))*100 as DeathPerPopulationPercentage
FROM Portfolio_project..CovidDeaths
--WHERE location = 'Egypt'
WHERE continent is not null
GROUP BY continent
ORDER BY 2 desc

SELECT date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage --total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM Portfolio_project..CovidDeaths
WHERE continent is not null and new_cases != 0
GROUP BY date
ORDER BY 1,2

SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage --total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM Portfolio_project..CovidDeaths
WHERE continent is not null and new_cases != 0
--GROUP BY date
ORDER BY 1,2

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated, (RollingPeopleVaccinated/dea.population)*100 as VaccinatedPopulation
FROM CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/dea.population)*100 as VaccinatedPopulation
FROM CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100 as PercentVaccinatedPopulation
FROM PopvsVac

DROP Table if exists #PercentVaccinatedPopulation
Create Table #PercentVaccinatedPopulation
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentVaccinatedPopulation
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/dea.population)*100 as VaccinatedPopulation
FROM CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100 as PercentVaccinatedPopulation
FROM #PercentVaccinatedPopulation

Create View PercentVaccinatedPopulation as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/dea.population)*100 as VaccinatedPopulation
FROM CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *
FROM PercentVaccinatedPopulation

