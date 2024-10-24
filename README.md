# Exploratory Data Analysis on Covid-19 Data|SQL project

## Project Overview
  

The project involves setting up a Covid_19 database in SSMS, performing exploratory data analysis (EDA), and answering specific questions about deaths and vaccinacted population accross the world through SQL queries.

**Dataset Link**: [Covid-19 Data](https://ourworldindata.org/covid-deaths). 

## Objectives

1. **Data Import**: Import the Data in SQL Server Management Studio
2. **Data Sorting**: Sort the data according to location and data.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Analysis**: Use SQL to answer specific questions and derive insights from the Covid-19 data.

## Project Structure

### 1. Data Sorting

- **Sort**: Sort the data for Covid_Deaths according to location and date

```sql
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio_Project..Covid_Deaths$
ORDER BY 1, 2;
```

### 2. Data Analysis & Findings

The following SQL queries were developed to answer specific questions:

1. **Write a SQL query to find percenatge of deaths to the total number of affected cases**:
```sql
SELECT location, date, population,  total_cases, (CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))*100 as DeathPercentage
FROM Portfolio_Project..Covid_Deaths$
ORDER BY 1, 2;
```

2. **Write a SQL query to retrieve max affected people in every location and percentage of affected people to the total population**:
```sql
SELECT location, population,  MAX(total_cases) as highestinfectioncount, MAX((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)))*100 as PercentagePopulationinfected
FROM Portfolio_Project..Covid_Deaths$
GROUP By location, population
ORDER BY PercentagePopulationinfected DESC;
```

3. **Write a SQL query to retrieve max deaths in every location and percentage of affected people to the total population****:
```sql
SELECT location, population,  MAX(total_deaths) as highestdeathcount, MAX((CONVERT(float, total_deaths) / NULLIF(CONVERT(float, population), 0)))*100 as PercentagePopulationdied
FROM Portfolio_Project..Covid_Deaths$
GROUP By location, population
ORDER BY PercentagePopulationdied DESC;
```

4. **Write a SQL query to find total death count in every continent**:
```sql
SELECT continent,  MAX(convert(float,total_deaths)) as highestdeathcount
FROM Portfolio_Project..Covid_Deaths$
WHERE continent is not NULL
GROUP By continent
ORDER BY highestdeathcount DESC;
```

5. **Write a SQL query to find new cases and new deaths**:
```sql
SELECT date, SUM(new_cases), SUM(new_deaths)
FROM Portfolio_Project..Covid_Deaths$
WHERE continent is not NULL
GROUP BY date
ORDER BY 1, 2;
```

6. **Write a SQL query to Join the table for Covid_Deaths and Covid_Vaccinations**:
```sql
SELECT *
FROM Portfolio_Project..Covid_Deaths$ dea
join Portfolio_Project..Covid_Vaccinations$ vac
  on dea.location = vac.location
  and dea.date =vac.date; 
```

7. **Write a SQL query to find vaccinated people that were affected according to location and date**:
```sql

  SELECT dea.continent, dea.location, dea.date, dea. population, vac.new_vaccinations, 
  SUM(Convert(float,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS rollingpeoplevaccinated
FROM Portfolio_Project..Covid_Deaths$ dea
join Portfolio_Project..Covid_Vaccinations$ vac
  on dea.location = vac.location
  and dea.date =vac.date
  WHERE dea.continent is not NULL
  ORDER by 2, 3;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales**:
```sql
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```
9. **Using CTE to Solve the same problem**

```sql
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
```

## Findings

- **Infection Trends**: The analysis to show how many new cases of infected people came everyday.
- **Data Insights**: The analysis identifies the locations and continents affected by Covid-19 and where Vaccinations were provided.

## Reports

- **Sales Summary**: A detailed report summarizing total deaths, total vaccination, and infection trend.
- **Trend Analysis**: Insights into sales trends across different months and shifts.

## Conclusion

This project serves as a comprehensive introduction to insights of how much world was affected by Covid-19 acoording to their location and Date.

