# COVID-19 Data Exploration & Visualization

A data analysis project exploring global COVID-19 case, death, and vaccination data using SQL Server for data exploration and Power BI for visualization.

## Overview

This project analyzes COVID-19 data to uncover trends in infection rates, mortality, and vaccination progress across countries and continents. It combines SQL-based exploratory data analysis with an interactive Power BI report to visualize the findings.

## Contents

|File                              |Description                                                                           |
|----------------------------------|--------------------------------------------------------------------------------------|
|`Exploratory_Data_Analysis.sql`   |SQL script performing exploratory data analysis on COVID-19 death and vaccination data|
|`Covid 19 Visual Data Report.pbix`|Power BI dashboard visualizing key COVID-19 metrics                                   |

## Skills Demonstrated

- Joins
- Common Table Expressions (CTEs)
- Window functions
- Aggregate functions
- Data type conversion
- Creating SQL views for downstream visualization
- Power BI dashboard design

## Analysis Highlights

The SQL script explores:

- **Death percentage** — likelihood of dying after contracting COVID-19, by location
- **Contraction percentage** — share of a country’s population infected with COVID-19
- **Infection rates by country** — countries with the highest infection counts relative to population
- **Mortality by country and continent** — total deaths grouped by location
- **Vaccination progress** — rolling count of vaccinated population over time, using window functions and a CTE, with a SQL view created for use in Power BI

## Data Source

The analysis uses `CovidDeaths` and `CovidVaccinations` datasets (global COVID-19 case, death, and vaccination records).

## Tools Used

- **SQL Server (SSMS)** — data exploration and querying
- **Power BI** — data visualization and dashboarding

## How to Use

1. Load the `CovidDeaths` and `CovidVaccinations` datasets into SQL Server.
1. Run `Exploratory_Data_Analysis.sql` to reproduce the exploratory analysis and create the `PercentPopulationVaccinated` view.
1. Open `Covid 19 Visual Data Report.pbix` in Power BI Desktop to explore the interactive dashboard.

## Author

Sam