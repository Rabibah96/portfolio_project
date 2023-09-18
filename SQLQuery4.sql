SELECT *
FROM Portfolio_Project..Covid_Vaccinations$;

SELECT *
FROM Portfolio_Project..Covid_Deaths$;


SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio_Project..Covid_Deaths$
ORDER BY 1, 2;


SELECT location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
FROM Portfolio_Project..Covid_Deaths$
WHERE location like 'pakistan'
ORDER BY 1, 2;


SELECT location, date, population,  total_cases, (CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))*100 as DeathPercentage
FROM Portfolio_Project..Covid_Deaths$
--WHERE location like 'pakistan'
ORDER BY 1, 2;


SELECT location, population,  MAX(total_cases) as highestinfectioncount, MAX((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)))*100 as PercentagePopulationinfected
FROM Portfolio_Project..Covid_Deaths$
--WHERE location like 'pakistan'
GROUP By location, population
ORDER BY PercentagePopulationinfected DESC;



SELECT location, population,  MAX(total_deaths) as highestdeathcount, MAX((CONVERT(float, total_deaths) / NULLIF(CONVERT(float, population), 0)))*100 as PercentagePopulationdied
FROM Portfolio_Project..Covid_Deaths$
--WHERE location like 'pakistan'
GROUP By location, population
ORDER BY PercentagePopulationdied DESC;


SELECT continent,  MAX(convert(float,total_deaths)) as highestdeathcount
FROM Portfolio_Project..Covid_Deaths$
--WHERE location like 'pakistan'
WHERE continent is not NULL
GROUP By continent
ORDER BY highestdeathcount DESC;



SELECT date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
FROM Portfolio_Project..Covid_Deaths$
--WHERE location like 'pakistan'
WHERE continent is not NULL
ORDER BY 1, 2;




SELECT date, SUM(new_cases), SUM(new_deaths)-- total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
FROM Portfolio_Project..Covid_Deaths$
--WHERE location like 'pakistan'
WHERE continent is not NULL
GROUP BY date
ORDER BY 1, 2;


--Looking at total population Vs Vaccination

SELECT *
FROM Portfolio_Project..Covid_Deaths$ dea
join Portfolio_Project..Covid_Vaccinations$ vac
  on dea.location = vac.location
  and dea.date =vac.date; 


  SELECT dea.continent, dea.location, dea.date, dea. population, vac.new_vaccinations, 
  SUM(Convert(float,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS rollingpeoplevaccinated
  --(rollingpeoplevaccinated/ population)*100
FROM Portfolio_Project..Covid_Deaths$ dea
join Portfolio_Project..Covid_Vaccinations$ vac
  on dea.location = vac.location
  and dea.date =vac.date
  --WHERE dea.location like 'Pakistan'
  WHERE dea.continent is not NULL
  ORDER by 2, 3; 

  --use CTE

  with popvsvac(continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
  AS
  (
  SELECT dea.continent, dea.location, dea.date, dea. population, vac.new_vaccinations, 
  SUM(Convert(float,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS rollingpeoplevaccinated
  --(rollingpeoplevaccinated/ population)*100
FROM Portfolio_Project..Covid_Deaths$ dea
join Portfolio_Project..Covid_Vaccinations$ vac
  on dea.location = vac.location
  and dea.date =vac.date
  --WHERE dea.location like 'Pakistan'
  WHERE dea.continent is not NULL
  --ORDER by 2, 3
  )
  SELECT *, (rollingpeoplevaccinated/population)*100
  FROM popvsvac;


  --TEMP TABLE
  
  DROP table if exists #percentpopulationvaccinated
  Create table #percentpopulationvaccinated
  (
  continent nvarchar(225),
  location nvarchar(225),
  date datetime,
  population numeric,
  new_vaccinations numeric,
  rollingpeoplevaccianted numeric
  )

  insert into #percentpopulationvaccinated
  SELECT dea.continent, dea.location, dea.date, dea. population, vac.new_vaccinations, 
  SUM(Convert(float,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS rollingpeoplevaccianted
  --(rollingpeoplevaccinated/ population)*100
FROM Portfolio_Project..Covid_Deaths$ dea
join Portfolio_Project..Covid_Vaccinations$ vac
  on dea.location = vac.location
  and dea.date =vac.date
  --WHERE dea.location like 'Pakistan'
  --WHERE dea.continent is not NULL
  --ORDER by 2, 3

  SELECT *, (rollingpeoplevaccianted/population)*100
  FROM #percentpopulationvaccinated;  


  --creating view to ave data later for visualization



  


  SELECT *
  FROM percentpopulationvaccinated