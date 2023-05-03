library(tidyverse)
library(ggplot2)

#Improting the csv files
daily_activity <- read.csv("dailyActivity_merged.csv")
daily_sleep <- read.csv("sleepDay_merged.csv")
calories_per_day <- read.csv("dailyCalories_merged.csv")
calories_per_hour <- read.csv("hourlyCalories_merged.csv")
daily_steps <- read.csv("dailySteps_merged.csv")
daily_intensities <- read.csv("dailyIntensities_merged.csv")

#Exploring data
n_distinct(daily_activity$Id)
n_distinct(daily_sleep$Id)
n_distinct(daily_steps$Id)
n_distinct(daily_intensities$Id)
n_distinct(calories_per_day$Id)
n_distinct(calories_per_hour$Id)
#Every set except 2nd has 33 users

#Going deeper into data
daily_activity %>% select(TotalDistance, VeryActiveDistance, ModeratelyActiveDistance, LightActiveDistance, Calories) %>% summary()
daily_sleep %>% select(TotalMinutesAsleep, TotalTimeInBed) %>% summary()
daily_steps %>% select(StepTotal) %>% summary()
daily_intensities %>% select(SedentaryMinutes, LightlyActiveMinutes, FairlyActiveMinutes, VeryActiveMinutes) %>% summary()
calories_per_day %>% select(Calories) %>% summary()
calories_per_hour %>% summary(select(Calories))

#Most of the distance is light active
#It takes 40 minutes to fall asleep for user, 7 hours of sleep per session
#The amount of sedentary minutes is enormous
#The amount of FAirly active minutes and distance is the lowest

#According to medical research the 8000 steps decrease the chance of any mortal case by 51% so I will check how many days are making more and less than average steps which is 7638 and 8000
above_avg <- daily_steps$StepTotal > 7638
num_above_avg <- sum(above_avg)
num_above_avg

below_avg <- daily_steps$StepTotal < 7638
num_below_avg <- sum(below_avg)
num_below_avg

above8k <- daily_steps$StepTotal > 8000
num_above8k <- sum(above8k)
num_above8k

below8k <- daily_steps$StepTotal < 8000
num_below8k <- sum(below8k)
num_below8k
#In most of the days steps are below average and 8k

#Try to chek same data but per user(above is per day)
#Create new data frame to see avg steps per user
avg_steps_per_uesr <- aggregate(StepTotal ~ Id, data = daily_steps, FUN =mean)

avg_steps_per_uesr %>% summary(select(StepTotal))

above_avg_user <- avg_steps_per_uesr$StepTotal > 7638
num_above_avg_user <- sum(above_avg_user)
num_above_avg_user

below_avg_user <- avg_steps_per_uesr$StepTotal < 7638
num_below_avg_user <- sum(below_avg_user)
num_below_avg_user

above8k_user <- avg_steps_per_uesr$StepTotal > 8000
num_above8k_user <- sum(above8k_user)
num_above8k_user

below8k_user <- avg_steps_per_uesr$StepTotal < 8000
num_below8k_user <- sum(below8k_user)
num_below8k_user
#Most of the users are below avg and 8k steps

#I will add more data to see the most active and inactive time
hourly_intensities <- read.csv("hourlyIntensities_merged.csv")
hourly_steps <- read.csv("hourlySteps_merged.csv")

#Check them for consistency
n_distinct(hourly_intensities$Id)
n_distinct(hourly_steps$Id)

#explore new data
hourly_intensities %>% summary(select(ActivityHour, TotalIntensity, AverageIntensity))
hourly_steps %>% summary(select(StepTotal))
#In both cases we have 33 users

#Split and change format of the date and time in hourly_intensities

hourly_intensities$ActivityHour=as.POSIXct(hourly_intensities$ActivityHour, format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone())
hourly_intensities$time <- format(hourly_intensities$ActivityHour, format = "%H:%M:%S")
hourly_intensities$date <- format(hourly_intensities$ActivityHour, format = "%m/%d/%y")

#Find the most active hours use ggplot
intensities_plot <- hourly_intensities %>%
  group_by(time) %>%
  drop_na() %>%
  summarise(mean_intensities = mean(TotalIntensity))
ggplot(data = intensities_plot, mapping = aes(x = time, y = mean_intensities)) + geom_histogram(stat = "identity", fill = 'blue') + 
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title="Average Total Intensity vs. Time")


#Visualise some data

ggplot(data=daily_activity, aes(x=TotalSteps, y=Calories)) + 
  geom_point() + labs(title="Total Steps vs. Calories")
#More steps = more calories, so there could be a notification to do more steps or intensities to lose mora calories if user wants so

#Merge 2 datasets daily sleep and activity to find a possible correlation
names(daily_activity)[2] <- "Date"
names(daily_sleep)[2] <- "Date"
daily_activity$Date=as.POSIXct(daily_activity$Date, format="%m/%d/%Y", tz=Sys.timezone())
daily_sleep$Date=as.POSIXct(daily_sleep$Date, format="%m/%d/%Y", tz=Sys.timezone())

merged_sleep_and_activity <- merge(daily_sleep, daily_activity, by=c('Id', 'Date'))
head(merged_sleep_and_activity)

ggplot(data=daily_activity, aes(x=TotalSteps, y=Calories)) + 
  geom_point() + geom_smooth() + labs(title="Steps vs. Calories")

ggplot(data = merged_sleep_and_activity, mapping = aes(x = TotalMinutesAsleep, y = SedentaryMinutes)) + 
  geom_smooth() + 
  geom_point()
  labs(title = "Sleeping time vs Sedentary time")
#NEgative correlation
