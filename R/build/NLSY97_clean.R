# Builds the cleaned NLSY97 dataset on incarceration status for analysis
# Read the colwise and rowwise vignettes carefully to understand this code.
# vignette("colwise")
# vignette("rowwise")

read_csv(here("data/NLSY97_raw.csv")) %>%
  
  # refused responses(-1), don't know(-2), valid skip(-4), non-interview(-5), or already incarcerated(99) --> NA
  # starts_with("E") are the columns that hold incarceration status per month of 2002
  mutate(across(starts_with("E"), ~case_when(
    .x < 0   ~ NA_real_,
    .x == 99 ~ NA_real_,
    TRUE     ~ .x
  ))) %>%
  
  # write to a temporary csv
  # write_csv(here("data/NLSY97_clean_temp1.csv"))
  
  # if you had NAs for the entire year, remove you
  filter(if_any(starts_with("E"), ~!is.na(.x))) %>%
  
  # sum across the months using rowwise
  rowwise() %>%
  mutate(total_incarceration = sum(c_across(starts_with("E")), na.rm = TRUE)) %>%
  ungroup() %>%

  # recode the gender variable
  mutate(gender = if_else(R0536300 == 1, "Male", "Female")) %>%
  
  # recode the race variable
  mutate(race = case_when(
    R1482600 == 1 ~ "Black",
    R1482600 == 2 ~ "Hispanic",
    R1482600 == 3 ~ "Mixed Race (Non-Hispanic)",
    R1482600 == 4 ~ "Non-Black / Non-Hispanic",
  )) %>%
  
  # finally, select the variables that will be used in the analysis
  select(race, gender, total_incarceration) %>%
  
  # write to a csv
  write_csv(here("data/NLSY97_clean.csv"))