use portfolio;

#data selection
select location,date, total_cases, new_cases, total_deaths, population
from coviddeaths
order by 1,2;


#total cases vs total deaths (greece)

select location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from coviddeaths
where location = 'Greece'
order by 1,2;

#total cases vs population
select location,date, total_cases, population, (total_cases/population)*100 as cases_percentage
from coviddeaths
where location = 'Greece'
order by 1,2;

#countries with highest infection rates compared to population
select location,population, MAX(total_cases) as highestinfectioncount, total_deaths, max((total_cases/population))*100 as percentPopulationInfected
from coviddeaths
group by Location, population
order by percentPopulationInfected desc;

#countries with highest death count 
select location, MAX(cast(total_deaths as unsigned)) as TotalDeathCount
from coviddeaths
where continent  != '' 
group by Location
order by TotalDeathCount desc;

#continents with highest death count 
select continent, MAX(cast(total_deaths as unsigned)) as TotalDeathCount
from coviddeaths
where continent  != '' 
group by continent
order by TotalDeathCount desc;

#global numbers
select date, SUM(new_cases), sum(new_deaths), sum(new_deaths )/sum(new_cases)*100 as deathRatio
from coviddeaths
#group by date
order by 1,2;


#population vs vaccination

with Popvsvac(Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as(
select dea.continent, dea.location,  dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations ) over (partition by dea.location order by dea.location, dea.date ) as RollingPeopleVaccinated
from coviddeaths dea
join covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date 
where dea.continent != ''
and  new_vaccinations !=''
order by 2,3)

select * from Popvsvac;

#Temporary Table

#Create View for Data
Create View PercentPopulationVaccinated as
select dea.continent, dea.location,  dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations ) over (partition by dea.location order by dea.location, dea.date ) as RollingPeopleVaccinated
from coviddeaths dea
join covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date 
where dea.continent != ''
and  new_vaccinations !='';

