# Builds a bar graph with total arrests on the y axis and race/gender on the
# x axis. Refer to my presentation on graphing for more detail.

read_csv(here("data/NLSY97_clean.csv")) %>%
  group_by(race, gender) %>%
  summarize(total_incarceration = mean(total_incarceration)) %>%
  ggplot(aes(race, total_incarceration, fill = gender)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(
      x = "Race", 
      y = "Mean Incarceration", 
      fill = "Gender",
      title = "Mean Number of Incarceration in 2002 by Race and Gender") +
    theme_minimal() +
    scale_fill_economist()

ggsave(here("figures/incarceration_by_racegender.png"), width=8, height=4.5)
