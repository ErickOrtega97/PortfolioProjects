SELECT *
From Covid_Project..Covid_Deaths
WHERE continent is not NULL

SELECT *
From Covid_Project..Covid_Vaccinations

---- Select data that we are going to use

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM Covid_Project..Covid_Deaths
ORDER BY 1,2

-- Total cases vs total deaths/ Likelihood of death if infection

SELECT Location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 AS DeathPercentage
FROM Covid_Project..Covid_Deaths
ORDER BY 1,2


-- Total Cases vs population / Population that has been infected
SELECT Location, date, total_cases, total_deaths, population, ROUND((total_cases/population)*100, 2) AS PercentInfected
FROM Covid_Project..Covid_Deaths
WHERE location = 'United States'
ORDER BY 1,2


-- Countries with highest infection rates

SELECT Location, population, MAX(total_cases) AS HighestInfectionCount, ROUND(MAX((total_cases/population))*100, 2) AS PercentInfected
FROM Covid_Project..Covid_Deaths
GROUP BY Location, population
ORDER BY PercentInfected DESC

-- Countries with highest death count
SELECT Location, MAX(cast(Total_deaths AS int)) AS TotalDeathCount
FROM Covid_Project..Covid_Deaths
WHERE continent is not null
GROUP BY Location, population
ORDER BY TotalDeathCount desc

-- Break down by continent group

SELECT continent, MAX(cast(Total_deaths AS int)) AS TotalDeathCount
FROM Covid_Project..Covid_Deaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

-- Showing continents with highest death count

SELECT continent, MAX(cast(Total_deaths AS int)) AS TotalDeathCount
FROM Covid_Project..Covid_Deaths
WHERE continent is not null
GROUP BY continent, population
ORDER BY TotalDeathCount desc



-- Global numbers
SELECT SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM Covid_Project..Covid_Deaths
Where continent is not null
--GROUP BY date
order by 1,2


-- Total population vs Vaccinated

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations AS int)) OVER (Partition By dea.location ORDER by dea.location, dea.date) AS Rolling_vaccination_Count
FROM Covid_Project..Covid_Deaths AS Dea
JOIN Covid_Project..Covid_Vaccinations AS Vac
	On dea.location = vac.location
	And dea.date = vac.date
Where dea.continent is not null
order by 2,3

--Use CTE

With PopvsVac (Continent, Location, Date, population, New_Vaccinations, Rolling_Vaccination_count)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations AS int)) OVER (Partition By dea.location ORDER by dea.location, dea.date) AS Rolling_vaccination_Count
FROM Covid_Project..Covid_Deaths AS Dea
JOIN Covid_Project..Covid_Vaccinations AS Vac
	On dea.location = vac.location
	And dea.date = vac.date
Where dea.continent is not null
)
SELECT *, ROUND((Rolling_Vaccination_count/population)*100, 2) AS Vaccinated_percent
FROM PopvsVac



--Temp table

DROP Table if exists #PercentPopulationVaccinated
CREATE table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
date datetime,
Population numeric,
New_Vaccinations numeric,
Rolling_Vaccination_Count numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations AS bigint)) OVER (Partition By dea.location ORDER by dea.location, dea.date) AS Rolling_vaccination_Count
FROM Covid_Project..Covid_Deaths AS Dea
JOIN Covid_Project..Covid_Vaccinations AS Vac
	On dea.location = vac.location
	And dea.date = vac.date
Where dea.continent is not null

SELECT *, ROUND((Rolling_Vaccination_count/population)*100, 2) AS Vaccinated_percent
FROM #PercentPopulationVaccinated


-- Creating View to store data for visualization

CREATE View PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations AS bigint)) OVER (Partition By dea.location ORDER by dea.location, dea.date) AS Rolling_vaccination_Count
FROM Covid_Project..Covid_Deaths AS Dea
JOIN Covid_Project..Covid_Vaccinations AS Vac
	On dea.location = vac.location
	And dea.date = vac.date
Where dea.continent is not null

SELECT *
FROM PercentPopulationVaccinated
