# Building a case for human-induced global warming

<img src="/data/images/anomaly2000.png" alt="temperature anomaly 2000" width="600"/>

## Introduction
The aim of this project is to show that the atmospheric CO<sub>2</sub> concentration as a result of human-related activities is causing the average global temperature to rise. We have found evidence, from available data, to support this fact by showing that a correlation exists between temperature anomaly and CO<sub>2</sub> concentration and that no such correlations exist with other climate-related measurements.

Once this evidence is established, our focus is turned to a predictive model of the temperature anomaly and CO<sub>2</sub> concentration. We develop a simple model based on differential equations, and calculate the best-fitting parameters using a least-squares optimization algorithm on the sum of squared residuals between the model and the data. Finally, a Bayesian statistical approach is used to fit the model to the data and obtain appropriate 95% credible intervals.

## Directory structure
`data` contains all data used throughout the project.<br>
  - `downloads` contains the original data before processing.
  - `processed` contains the processed data.
  - `images` contains any generated images.

`scripts` contains all code written throughout the project.<br>
  - `preprocessing.ipynb` contains the code for pre-processing the downloaded data.
  - `cross_correlations.R` performs the cross-correlation analysis.
  - `temperature_map.R` creates various temperature maps.
  - `RStanODEModel.R` and `ode.stan` performs Bayesian temperature modelling.
  - `main.ipynb` main Python script collating the analyses.

## Data

All of the data used is freely available.

- Temperature data was accessed from the [NASA GISSTEMP v4](https://data.giss.nasa.gov/gistemp/) dataset, which consists of monthly anomaly estimates on a 2°×2° grid from 1880 to present. 
- CO2  data was accessed from the [NOAA GML](https://gml.noaa.gov/ccgg/trends/data.html) dataset, which consists of monthly atmospheric CO2 concentrations at the Mauna Loa Observatory in Hawaii from 1958 to present.
- Volcanic activity data was accessed from the [Global Volcanism Program](https://volcano.si.edu/search_eruption.cfm) dataset, which details all recorded eruptions in recent history.
- Solar irradiance data was accessed from the [NOAA CDR](https://www.ncei.noaa.gov/access/metadata/landing-page/bin/iso?id=gov.noaa.ncdc:C00828) dataset, which contains yearly averaged solar irradiance values from 1880 to present.

This data is preprocessed before analysis.

## Requirements and Installation

![python](https://img.shields.io/badge/Python-3.11-426E9C.svg)
![R](https://img.shields.io/badge/R-4.3-3266B2.svg)
![stan](https://img.shields.io/badge/Stan-2.26.1-A42025.svg)

The [Python](https://www.python.org/) programming language (version 3.11) is used for most of the analysis in this project, with the [R](https://www.r-project.org/) programming language (version 4.3) and [Stan](https://mc-stan.org/) probabilistic programming language (version 2.26.1) being used for certain tasks.

- Jupyter notebooks are used for all Python code. The easiest way to install Jupyter notebooks is through the [Anaconda](https://www.anaconda.com/) platform.

- The standard Python tools for statistical data analysis are used. These include the ``pandas``, ``numpy`` and ``scipy`` packages. The preprocessing of the data requires the ``xarray`` and ``netCDF4`` Python packages. Python packages can be installed using ``conda install package_name`` if using Python through the Anaconda platform, or using ``pip install package_name`` otherwise.

- The ``ggplot2``, ``ggmap``, ``testcorr``, ``rstan`` and ``HDInterval`` packages are required for running the R and Stan scripts. R packages can be installed using ``install.packages("package_name")``. 

## Usage

The recommended usage is as follows:
1. Download the contents of `data` and `scripts`.
2. Install all necessary software and packages.
3. Run `preprocessing.ipynb` to prepare the downloaded data for analysis.
4. Run `cross_correlations.R` to perform the correlation analysis.
5. Run `RStanODEModel.R` to perform the Bayesian temperature modelling.
6. Run `temperature_map.R` to generate useful temperature plots.
7. Run `main.ipynb` to view the analyses and relevant plots together.

## License
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)


## Authors
Adam Watt<br>
Seán O'Neill






