#initial read of surveys data read csv file (local - use a relative path)
surveys <- read.csv("data/portal_data.csv")
#get first six lines
head(surveys) str(surveys) dim(surveys) nrow(surveys) ncol(surveys) summary(surveys) sex <- 
surveys$sex nlevels(sex) year <- surveys$year year_factor <- as.factor(year) 
levels(year_factor) head(surveys) library(lubridate) surveys$date <- 
ymd(paste(surveys$year,surveys$month,surveys$day, sep="-")) summary(surveys$date) 
library(tidyverse) is.na(surveys$date) #get true/false of whether date is NA - returns vector 
head(filter(surveys, is.na(date))) #check why there are NA in date - note 31Sep
#need to filter weird dates - see below CHALLENGE: filter out data (and make a new dataset) 
#where the date is wrong
surveys_gooddates <- filter(surveys,!is.na(date))
#CHALLENGE: filter data for rows where year == 1995
filter(surveys, year == 1995)
#hard ways to read - functions inside functions
head(select(surveys, species_id, weight))
#easier way - use pipes to send data to next command
surveys %>% head() #same as head(surveys) surveys %>% filter(is.na(date)) %>% head() surveys 
%>% filter(is.na(date)) %>% select(year,month,day) %>% head() surveys_weight <- surveys %>%
  filter (is.na(date)) %>%
  mutate(weight_kg=weight/1000) surveys_complete <- surveys %>%
  filter(is.na(weight),
        !is.na(hindfoot_length),
        !is.na(sex),
        sex != "") surveys_complete2 <- surveys %>% drop_na()
#find commun species more than 50 smaples
surveys_complete2 %>% count(species_id) %>%
  filter (n>50) species_common <- surveys_complete2 %>% count(species_id) %>%
  filter (n>50) speceis_complete_common <- surveys_complete2 %>%
  filter(species_id %in% species_common$species_id) write_csv(speceis_complete_common,
          path = "processed_data/speceis_complete_common.csv") surveys_complete_common <- 
read_csv("processed_data/speceis_complete_common.csv")
#basic plots using ggplot
ggplot(data= surveys_complete_common,
       aes(x= weight, y= hindfoot_length,)) +
  geom_point(alpha = .1, aes (color = species_id)) plot_weight_hind <- ggplot(data= 
surveys_complete_common,
       aes(x= weight, y= hindfoot_length,)) plot_weight_hind +
  geom_point(aes(color=species_id)) plot_weight_hind <- ggplot(data= surveys_complete_common,
                           aes(x= species_id, y= weight,)) plot_weight_hind +
  geom_boxplot(aes(color=species_id))+
  geom_jitter(alpha = .1, aes(color=plot_type))+
  geom_violin()
#challenge
yearly_count <- surveys_complete_common %>%
  count(year,species_id) plot_year <- ggplot(yearly_count,
       aes(x=year, y = n, color = species_id))+
  geom_line() + facet_wrap(~species_id) +
  theme_bw() +
  theme(panel.grid = element_blank()) ggsave(plot = plot_year, filename = 
"figures/plot_year")
#CLASE DE 5 DE JUNIO Challenge: how many individuals were caught in each plot_id
surveys %>% filter (!is.na (weight)) %>%
  group_by(species_id,sex) %>%
  summarise(mean_weight=mean(weight),
            min_weight=min(weight),
            max_weight= max(weight)) %>%
  arrange(desc(mean_weight))
# challenge : find min, max hindfoot_length for each species
surveys %>% filter (!is.na (hindfoot_length)) %>%
  group_by(hindfoot_length, species_id) %>%
  summarise(mean_hindfoot_length=mean(hindfoot_length),
            min_hindfoot_length=min(hindfoot_length),
            max_hindfoot_length= max(hindfoot_length)) %>%
  arrange(desc(mean_hindfoot_length))
# challenge: find the genus and species of the heaviest individual each year
surveys %>% filter (!is.na (weight)) %>%
  group_by(year) %>%
  filter(weight==max(weight)) %>%
  select(year,genus,species_id,weight)
#challenge mean weight of each species in each plot
survey_mean_weight_plot <- surveys %>% filter(!is.na(weight)) %>%
  group_by(plot_id,species_id) %>%
  summarize(mean_weight=mean(weight)) survey_mean_weight_plot2 <- survey_mean_weight_plot %>%
  spread(key=species_id, value = mean_weight)
#gather wide date to long format
survey_mean_weight_plot_long <- survey_mean_weight_plot %>%
  gather(key = plot_number, value = m_weight, -species_id)
#chalenge spread survey where there is a row for each plot_id and columns for years value is 
#the bumber speceis_id per plot summarize first use the function n_distinct (use ? for help 
#as needed)
surveys %>% group_by(plot_id,year) %>%
  summarise(n_species=n_distinct(species_id))%>%
  spread(key=year,value = n_species) surveys_numsp_year_plot <- surveys %>% count(plot_id, 
year, species_id) %>%
  count(plot_id, year) %>% spread (year,n)
#challenge each row is a unique year and plot_id
surveys_numsp_year_plot_long <- surveys_numsp_year_plot %>%
  gather(year, number_spp_caught, -plot_id) surveys_long <- surveys %>%
  gather (measurement, value, hindfoot_lenght:weight) install.packages(c("dbplay", 
"RSQLite")) download.file(url = "https://ndownloader.figshare.com/files/2292171",
              destfile= "data/portal_mammals.sqlite", mode = "wb") library(dbplyr) mammals <- 
DBI::dbConnect(RSQLite::SQLite(),
                          "data/portal_mammals.sqlite") src_dbi(mammals) surveys_db <- 
tbl(mammals,"surveys") surveys_db %>% select (species_id, year, plot_id) %>% nraw(surveys_id)
# get samples weight <5, select a few cols
surveys_db %>% filter(weight < 5) %>% select(species_id,year) %>%
  collect() colnames(surveys_db) plots_db <- tbl(mammals,"plots") species_db <- 
tbl(mammals,"species") colnames(plots_db) colnames(species_db)
# get the number of rodents in each plot
rodent_per_plot <- left_join(surveys_db,species_db) %>% filter(taxa=="Rodent") %>%
  group_by(taxa,year) %>% tally %>% collect()
#total nubers of rodents in each genus caught in differents plot types
left_join(surveys_db,plots_db)%>% left_join(species_db)%>%
  filter(taxa=="Rodents")%>% group_by(genus,plot_type) %>%
  tally %>% collect()
