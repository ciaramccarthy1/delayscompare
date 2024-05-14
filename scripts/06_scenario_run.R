source("~/delayscompare/scripts/01_packages.R")
source(here("R", "scenario_loop.R"))

## Load data ##

ebola_sim_data <- readRDS(here("data", paste0("ebola_sim_data", "2024-04-11", ".rds")))
ebola_reporting_delay <- readRDS(here("data", "ebolareportingdelay.rds"))
covid_sim_data <- readRDS(here("data", paste0("covid_sim_data", "2024-04-11", ".rds")))

# In required format for EpiNow2

ebola_sim_data_cases <- ebola_sim_data |> filter(variable=="reported_cases")
ebola_sim_data_cases <- ebola_sim_data_cases |>
  select(date, value) |>
  rename(confirm=value)

covid_sim_data_cases <- covid_sim_data |> filter(variable=="reported_cases")
covid_sim_data_cases <- covid_sim_data_cases |>
  select(date, value) |>
  rename(confirm=value)

## Ebola ##

res_ebola <- sim_scenarios(case_data=ebola_sim_data_cases,
                           gen_mean=16.2,
                           gen_sd=9.40, # from Park et al. 2019
                           inc_mean=11.4,
                           inc_sd=8.1, # from Aylward et al. 2014 
                           rep_meanlog=ebola_reporting_delay$mean_mean,
                           rep_sdlog=ebola_reporting_delay$sd_mean,
                           freq_fc=4,
                           weeks_inc=12,
                           obs_scale=0.83)

saveRDS(res_ebola[[1]], here("results", paste0("res_ebola", Sys.Date(), ".rds")))
saveRDS(res_ebola[[2]], here("results", paste0("res_ebola_id", Sys.Date(), ".rds")))

## COVID-19 ##

res_covid <- sim_scenarios(case_data=covid_sim_data_cases,
                           gen_mean=3.6,
                           gen_sd=3.1, # from Sherratt et al. 2021 - surveillance paper
                           inc_mean=5.2,
                           inc_sd=1.52, # from Sherratt et al. 2021 - surveillance paper
                           rep_meanlog=convert_to_logmean(4.4, 5.6),
                           rep_sdlog=convert_to_logsd(4.4, 5.6), # MAXIMUM IS JUST A PLACEHOLDER # from Sherratt et al. 2021 - surveillance paper
                           freq_fc=4,
                           weeks_inc=12,
                           obs_scale=0.4)
saveRDS(res_covid[[1]], here("results", paste0("res_covid", Sys.Date(), ".rds")))
saveRDS(res_covid[[2]], here("results", paste0("res_covid_id", Sys.Date(), ".rds")))