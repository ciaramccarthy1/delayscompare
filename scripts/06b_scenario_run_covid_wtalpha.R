library(here)

source(here("scripts", "01_packages.R"))
source(here("R", "funcs_data.R"))
source(here("R", "scenario_loop.R"))

## Load argument(s) ##
var <- commandArgs(trailingOnly = T)
gt <- as.numeric(var[1])
print(gt)

## Load data ##

covid_sim_data <- read_latest(here("data"), "covid_sim_data")

## Just wt and Alpha waves

covid_sim_data <- covid_sim_data |> filter(date<="2021-04-30")

# In required format for EpiNow2

covid_sim_data_cases <- covid_sim_data |> filter(variable=="reported_cases")
covid_sim_data_cases <- covid_sim_data_cases |>
  select(date, value) |>
  rename(confirm=value)

## Run scenarios ##

res_covid <- sim_scenarios(case_data=covid_sim_data_cases,
                           var=gt,
                           gen_mean=3.6,
                           gen_sd=3.1, # from Sherratt et al. 2021 - surveillance paper
                           gen_max=30,
                           inc_mean=5.2,
                           inc_sd=1.52, # from Sherratt et al. 2021 - surveillance paper
                           inc_max=30,
                           rep_meanlog=convert_to_logmean(4.4, 5.6),
                           rep_sdlog=convert_to_logsd(4.4, 5.6), # MAXIMUM IS JUST A PLACEHOLDER # from Sherratt et al. 2021 - surveillance paper
                           rep_max=30,
                           freq_fc=4,
                           weeks_inc=12,
                           obs_scale=0.4)


#save_latest(res_covid[[1]], here("results"), "res_covid")
save_latest(res_covid[[2]], here("results"), paste0("res_covid_id", gt))
save_latest(res_covid[[3]], here("results"),  paste0("res_covid_warnings", gt))

## Saving samples only ##
save_latest(res_covid[[1]], here("results"),  paste0("res_covid_samples", gt))
save_latest(res_covid[[4]], here("results"),  paste0("res_covid_R", gt))


