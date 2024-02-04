select *
from PortfolioProject..CovidDeaths
order by 3,4

--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

-- Select Data that we are going to be using

select location, date, total_cases, new_cases, total_deaths,population
from PortfolioProject..CovidDeaths
order by 1,2


-- Looking at Total Cases vs Total Deaths 
-- Shows the likelihood of dying if you contract covid in your country 
SELECT 
    location, 
    date, 
    total_cases, 
    total_deaths, 
    IIF(TRY_CONVERT(INT, total_cases) = 0, NULL, TRY_CONVERT(DECIMAL(10, 2), total_deaths) / TRY_CONVERT(DECIMAL(10, 2), total_cases) * 100) AS DeathPercentage
FROM PortfolioProject..CovidDeaths
--where location like '%states%'
ORDER BY 1,2;

-- Looking at Total Cases vs Population

SELECT 
    location, 
    date, 
    total_cases, 
    population,
	(total_cases/population)*100 AS PercentageofPopulationInfected
FROM PortfolioProject..CovidDeaths
where continent is not null
--where location like '%states%'
ORDER BY 1,2;


--Countries with the highest infection rate compared to the population

SELECT 
    location,population, 
    max(total_cases) as HighestInfectionCount, 
	Max((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
where continent is not null
--where location like '%states%'
group by location, population
ORDER BY PercentPopulationInfected Desc;


-- Let's break things down by continent

SELECT 
    continent, 
    max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by continent
ORDER BY TotalDeathCount Desc;



-- Countries with the highest death count per population

SELECT 
    location, 
    max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is null
group by location
ORDER BY TotalDeathCount Desc;


-- Continents with the highest death count per population

SELECT 
    continent, 
    max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by continent
ORDER BY TotalDeathCount Desc


-- Global numbers 

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(new_deaths)/sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


-- Total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint, isnull(vac.new_vaccinations,0))) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3

--use cte

with PopVsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint, isnull(vac.new_vaccinations,0))) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)

select *, (RollingPeopleVaccinated/Population)*100
from PopVsVac


--Creating view to store data for visualization

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint, isnull(vac.new_vaccinations,0))) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select * from PercentPopulationVaccinated








