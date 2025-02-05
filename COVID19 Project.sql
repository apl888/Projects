-- COVIDDeaths datatable

SELECT *
FROM COVID19Project.dbo.CovidDeathsEDITcsv
ORDER BY 3,4;

--Select data that we are going to be using

SELECT 
	Location, 
	date, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population
FROM COVID19Project.dbo.CovidDeathsEDITcsv
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- Total cases vs total deaths as a percent

-- All countries
SELECT 
	Location, 
	date, 
	total_cases, 
	total_deaths, 
	(CAST(total_deaths AS DECIMAL(12,2)) / CAST(total_cases AS DECIMAL(12,2)))*100 AS DeathPercentage
FROM COVID19Project.dbo.CovidDeathsEDITcsv
WHERE continent IS NOT NULL
ORDER BY 1,2;

CREATE VIEW total_cases_vs_total_deaths
AS
SELECT 
	Location, 
	date, 
	total_cases, 
	total_deaths, 
	(CAST(total_deaths AS DECIMAL(12,2)) / CAST(total_cases AS DECIMAL(12,2)))*100 AS DeathPercentage
FROM COVID19Project.dbo.CovidDeathsEDITcsv
WHERE continent IS NOT NULL
--ORDER BY 1,2;

-- Only the United States
SELECT 
	Location, 
	date, 
	total_cases, 
	total_deaths, 
	(CAST(total_deaths AS DECIMAL(12,2)) / CAST(total_cases AS DECIMAL(12,2)))*100 AS DeathPercentage
FROM COVID19Project.dbo.CovidDeathsEDITcsv
WHERE continent IS NOT NULL
AND location like '%states%'
ORDER BY 1,2;

CREATE VIEW total_cases_vs_total_deaths_US 
AS
SELECT
	Location, 
	date, 
	total_cases, 
	total_deaths, 
	(CAST(total_deaths AS DECIMAL(12,2)) / CAST(total_cases AS DECIMAL(12,2)))*100 AS DeathPercentage
FROM COVID19Project.dbo.CovidDeathsEDITcsv
WHERE continent IS NOT NULL
AND location like '%states%'
--ORDER BY 1,2;


-- Total cases vs population (percentage of population who contracted COVID-19)

-- All countries
SELECT
	Location, 
	date, 
	total_cases, 
	population,
	(CAST(total_cases AS DECIMAL(12,2)) / CAST(population AS DECIMAL(12,2)))*100 AS InfectedPopPrcnt
FROM COVID19Project.dbo.CovidDeathsEDITcsv
WHERE continent IS NOT NULL
ORDER BY 1,2;

CREATE VIEW total_cases_vs_pop
AS
SELECT
	Location, 
	date, 
	total_cases, 
	population,
	(CAST(total_cases AS DECIMAL(12,2)) / CAST(population AS DECIMAL(12,2)))*100 AS InfectedPopPrcnt
FROM COVID19Project.dbo.CovidDeathsEDITcsv
WHERE continent IS NOT NULL
--ORDER BY 1,2;

-- Only the United States
SELECT
	Location, 
	date, 
	total_cases, 
	population,
	(CAST(total_cases AS DECIMAL(12,2)) / CAST(population AS DECIMAL(12,2)))*100 AS InfectedPopPrcnt
FROM COVID19Project.dbo.CovidDeathsEDITcsv
WHERE continent IS NOT NULL
AND location like '%states%'
ORDER BY 1,2;

CREATE VIEW total_cases_vs_pop_US
AS
SELECT
	Location, 
	date, 
	total_cases, 
	population,
	(CAST(total_cases AS DECIMAL(12,2)) / CAST(population AS DECIMAL(12,2)))*100 AS InfectedPopPrcnt
FROM COVID19Project.dbo.CovidDeathsEDITcsv
WHERE continent IS NOT NULL
AND location like '%states%'
--ORDER BY 1,2;

-- Countries with the highest infection rate relative to population
SELECT
	Location, 
	Population,
	MAX(total_cases) AS MaxCases, 
	MAX((CAST(total_cases AS DECIMAL(12,2)) / CAST(population AS DECIMAL(12,2)))*100) AS InfectedPopPrcnt
FROM COVID19Project.dbo.CovidDeathsEDITcsv
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY InfectedPopPrcnt DESC;

CREATE VIEW countries_highest_infection_rate
AS 
SELECT
	Location, 
	Population,
	MAX(total_cases) AS MaxCases, 
	MAX((CAST(total_cases AS DECIMAL(12,2)) / CAST(population AS DECIMAL(12,2)))*100) AS InfectedPopPrcnt
FROM COVID19Project.dbo.CovidDeathsEDITcsv
WHERE continent IS NOT NULL
GROUP BY location, population
--ORDER BY InfectedPopPrcnt DESC;

-- Countries with highest deaths as a percent of population
SELECT
	Location, 
	Population,
	MAX(total_deaths) AS MaxDeathCount, 
	MAX((CAST(total_deaths AS DECIMAL(12,2)) / CAST(population AS DECIMAL(12,2)))*100) AS MaxDeathPrcnt
FROM COVID19Project.dbo.CovidDeathsEDITcsv
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY MaxDeathPrcnt DESC;

CREATE VIEW countries_highest_death_rates_prcnt_pop
AS
SELECT
	Location, 
	Population,
	MAX(total_deaths) AS MaxDeathCount, 
	MAX((CAST(total_deaths AS DECIMAL(12,2)) / CAST(population AS DECIMAL(12,2)))*100) AS MaxDeathPrcnt
FROM COVID19Project.dbo.CovidDeathsEDITcsv
WHERE continent IS NOT NULL
GROUP BY location, population
--ORDER BY MaxDeathPrcnt DESC;


-- Break down by continent

-- Continents with the highest death count
SELECT
	Continent, 
	MAX(total_deaths) AS MaxDeathCount, 
	MAX((CAST(total_deaths AS DECIMAL(12,2)) / CAST(population AS DECIMAL(12,2)))*100) AS MaxDeathPrcnt
FROM COVID19Project.dbo.CovidDeathsEDITcsv
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY MaxDeathPrcnt DESC;


-- A more accurate account of the highest death count by continent
SELECT
	Location, 
	MAX(total_deaths) AS MaxDeathCount, 
	MAX((CAST(total_deaths AS DECIMAL(12,2)) / CAST(population AS DECIMAL(12,2)))*100) AS MaxDeathPrcnt
FROM COVID19Project.dbo.CovidDeathsEDITcsv
WHERE continent IS NULL
GROUP BY location
ORDER BY MaxDeathPrcnt DESC;

CREATE VIEW continents_highest_death_count
AS
SELECT
	Location, 
	MAX(total_deaths) AS MaxDeathCount, 
	MAX((CAST(total_deaths AS DECIMAL(12,2)) / CAST(population AS DECIMAL(12,2)))*100) AS MaxDeathPrcnt
FROM COVID19Project.dbo.CovidDeathsEDITcsv
WHERE continent IS NULL
GROUP BY location
--ORDER BY MaxDeathPrcnt DESC;


-- Global numbers

-- Global numbers per day
SELECT 
	date, 
	SUM(new_cases) AS SumNewCases, 
	SUM(new_deaths) AS SumNewDeaths,
	SUM(CAST(new_deaths AS DECIMAL(12,2))) / SUM(CAST(new_cases AS DECIMAL(12,2)))*100 AS NewDeathPercentage
FROM COVID19Project.dbo.CovidDeathsEDITcsv
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1;

CREATE VIEW global_numbers_per_day
AS
SELECT 
	date, 
	SUM(new_cases) AS SumNewCases, 
	SUM(new_deaths) AS SumNewDeaths,
	SUM(CAST(new_deaths AS DECIMAL(12,2))) / SUM(CAST(new_cases AS DECIMAL(12,2)))*100 AS NewDeathPercentage
FROM COVID19Project.dbo.CovidDeathsEDITcsv
WHERE continent IS NOT NULL
GROUP BY date
--ORDER BY 1;

-- Global numbers totals to max date
SELECT 
	SUM(new_cases) AS SumNewCases, 
	SUM(new_deaths) AS SumNewDeaths,
	SUM(CAST(new_deaths AS DECIMAL(12,2))) / SUM(CAST(new_cases AS DECIMAL(12,2)))*100 AS NewDeathPercentage
FROM COVID19Project.dbo.CovidDeathsEDITcsv
WHERE continent IS NOT NULL;

CREATE VIEW global_numbers_to_max_date
AS 
SELECT 
	SUM(new_cases) AS SumNewCases, 
	SUM(new_deaths) AS SumNewDeaths,
	SUM(CAST(new_deaths AS DECIMAL(12,2))) / SUM(CAST(new_cases AS DECIMAL(12,2)))*100 AS NewDeathPercentage
FROM COVID19Project.dbo.CovidDeathsEDITcsv
WHERE continent IS NOT NULL;


-- COVID Vaccinations Data Table
SELECT 
* 
FROM COVID19Project.dbo.CovidVaccinationsEDITcsv;

-- join the CovidDeaths and CovidVaccinations tables
SELECT 
*
FROM COVID19Project.dbo.CovidDeathsEDITcsv dth
JOIN COVID19Project.dbo.CovidVaccinationsEDITcsv vac
	ON dth.location = vac.location 
	AND dth.date = vac.date;

-- Total population vs vaccinations
SELECT 
	dth.continent,
	dth.location,
	dth.date,
	dth.population,
	vac.new_vaccinations,
	SUM(new_vaccinations) OVER (PARTITION BY dth.location
								ORDER BY dth.location, dth.date) AS RollingSumNewVacs
FROM COVID19Project.dbo.CovidDeathsEDITcsv dth
JOIN COVID19Project.dbo.CovidVaccinationsEDITcsv vac
	ON dth.location = vac.location 
	AND dth.date = vac.date
WHERE dth.continent IS NOT NULL
ORDER BY 2,3;

CREATE VIEW vax_vs_pop
AS
SELECT 
	dth.continent,
	dth.location,
	dth.date,
	dth.population,
	vac.new_vaccinations,
	SUM(new_vaccinations) OVER (PARTITION BY dth.location
								ORDER BY dth.location, dth.date) AS RollingSumNewVacs
FROM COVID19Project.dbo.CovidDeathsEDITcsv dth
JOIN COVID19Project.dbo.CovidVaccinationsEDITcsv vac
	ON dth.location = vac.location 
	AND dth.date = vac.date
WHERE dth.continent IS NOT NULL
--ORDER BY 2,3;

-- Percent of population vaccinated (max number of vaccinations / pop per country)
-- Will use a CTE
WITH VacPopPrcnt (
Continent,
Location,
Date,
Population,
New_vaccinations,
RollingSumNewVacs)
AS
(
SELECT 
	dth.continent,
	dth.location,
	dth.date,
	dth.population,
	vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION BY dth.location
								ORDER BY dth.location, dth.date) AS RollingSumNewVacs
FROM COVID19Project.dbo.CovidDeathsEDITcsv dth
JOIN COVID19Project.dbo.CovidVaccinationsEDITcsv vac
	ON dth.location = vac.location 
	AND dth.date = vac.date
WHERE dth.continent IS NOT NULL
)
SELECT
*,
CAST(RollingSumNewVacs AS DECIMAL(12,2)) / CAST(population AS DECIMAL(12,2)) * 100 AS PrcntOfPop
FROM VacPopPrcnt;


-- Temp Table

DROP TABLE IF EXISTS #PercentPopVaccinated
CREATE TABLE #PercentPopVaccinated
(
Continent NVARCHAR(255),
Location NVARCHAR(255),
Date DATETIME,
Population NUMERIC,
New_vaccinations NUMERIC,
RollingSumNewVacs NUMERIC
)

INSERT INTO #PercentPopVaccinated
SELECT 
	dth.continent,
	dth.location,
	dth.date,
	dth.population,
	vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION BY dth.location
								ORDER BY dth.location, dth.date) AS RollingSumNewVacs
FROM COVID19Project.dbo.CovidDeathsEDITcsv dth
JOIN COVID19Project.dbo.CovidVaccinationsEDITcsv vac
	ON dth.location = vac.location 
	AND dth.date = vac.date
WHERE dth.continent IS NOT NULL
--ORDER BY 2,3

SELECT
*,
CAST(RollingSumNewVacs AS DECIMAL(12,2)) / CAST(population AS DECIMAL(12,2)) * 100 AS PrcntOfPop
FROM #PercentPopVaccinated;


-- Creating views to store data for visualizations

-- View: percent of the population that is vaccinated (continent and country)

CREATE VIEW PrcntPopVaccinated AS
SELECT 
	dth.continent,
	dth.location,
	dth.date,
	dth.population,
	vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION BY dth.location
								ORDER BY dth.location, dth.date) AS RollingSumNewVacs
FROM COVID19Project.dbo.CovidDeathsEDITcsv dth
JOIN COVID19Project.dbo.CovidVaccinationsEDITcsv vac
	ON dth.location = vac.location 
	AND dth.date = vac.date
WHERE dth.continent IS NOT NULL
--ORDER BY 2,3








-- switch to the COVID19Project database
USE COVID19Project;
GO