Use [SQL Project]

select * from CovidDeaths 

select * from CovidVaccinations

select * from CovidDeaths where location = 'Japan'

-- selecting the data that will be very helpful for the project

select location, date, total_cases, new_cases
from CovidDeaths order by 1,2

ALTER TABLE CovidDeaths ALTER COLUMN total_deaths decimal(18,2)

ALTER TABLE CovidDeaths ALTER COLUMN total_cases decimal(18,2)

-- Now checking the total cases vs total Deaths 

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths where location like '%states%'


-- Looking at the Total cases vs Population
-- Shows what percentage of population affected by covid

select Location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
from CovidDeaths 

select Location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
from CovidDeaths where Location Like 'africa' order by 3,4

-- location at countries with highest infection rate compared to population

select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
from CovidDeaths Group by Location, Population order By PercentagePopulationInfected desc

-- showing the highest death counts per population

select Location, MAX(total_deaths) as TotalDeathCount from CovidDeaths
where continent is not null
Group by Location Order By TotalDeathCount DESC

--Let's break things by continent

-- showing continents with the highest death count per population

select continent, MAX(Cast(total_deaths as int)) as TotalDeathCount from CovidDeaths
where continent is not null Group by continent
order by TotalDeathCount desc

-- Worldwide cases at the specific date

select date, SUM(new_cases) as Total_cases from CovidDeaths where continent is not null 
Group By date order by 1,2

select date, SUM(new_cases) as Total_cases, SUM(Cast(new_deaths as int)) as Total_Deaths
from CovidDeaths where continent is not null group by date
order by 1,2

select sum(new_cases) as Total_cases, SUM(Cast(new_deaths as int))
as total_deaths, SUM(cast(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
from CovidDeaths where continent is not null  order by 1,2

--Looking at total Population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from CovidDeaths dea JOIN CovidVaccinations vac ON 
dea.location = vac.location and dea.date = vac.date 
where dea.continent is not null order by 2,3

with PopvsVac (continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated from CovidDeaths dea JOIN CovidVaccinations vac ON
dea.location = vac.location and dea.date = vac.date where dea.continent is not null
)
select *,(RollingPeopleVaccinated/Population)*100
from PopvsVac

-- Temp table
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated from CovidDeaths dea JOIN CovidVaccinations vac ON
dea.location = vac.location and dea.date = vac.date 
-- where dea.continent is not null

select *,(RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

-- Creating view
Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated from CovidDeaths dea JOIN CovidVaccinations vac ON
dea.location = vac.location and dea.date = vac.date 





