
---
title: "Bellabeat Capstone"
author: "Nikolai Chakhvashvili"
date: "2023-05-02"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

### What is Bellabeat?

Urška Sršen and Sando Mur founded Bellabeat, a high-tech company that manufactures health-focused smart products.
Sršen used her background as an artist to develop beautifully designed technology that informs and inspires women around
the world. Collecting data on activity, sleep, stress, and reproductive health has allowed Bellabeat to empower women with
knowledge about their own health and habits.

### Questions for the analysis:

* ##### What are some trends in smart device usage?

* ##### How could these trends apply to Bellabeat customers?

* ##### How could these trends help influence Bellabeat marketing strategy?

### Buisness Task

##### Identify the trends of smart device usage and find opportunities for growth. Give recomendations based on the trends.

### Loading Tidyverse package

```{r}
library(tidyverse)
```

### Importing datasets

```{r}
daily_activity <- read.csv("/kaggle/input/fitbit/Fitabase Data 4.12.16-5.12.16/dailyActivity_merged.csv")
daily_sleep <- read.csv("/kaggle/input/fitbit/Fitabase Data 4.12.16-5.12.16/sleepDay_merged.csv")
calories_per_day <- read.csv("/kaggle/input/fitbit/Fitabase Data 4.12.16-5.12.16/dailyCalories_merged.csv")
calories_per_hour <- read.csv("/kaggle/input/fitbit/Fitabase Data 4.12.16-5.12.16/hourlyCalories_merged.csv")
daily_steps <- read.csv("/kaggle/input/fitbit/Fitabase Data 4.12.16-5.12.16/dailySteps_merged.csv")
daily_intensities <- read.csv("/kaggle/input/fitbit/Fitabase Data 4.12.16-5.12.16/dailyIntensities_merged.csv")
hourly_intensities <- read.csv("/kaggle/input/fitbit/Fitabase Data 4.12.16-5.12.16/hourlyIntensities_merged.csv")
hourly_steps <- read.csv("/kaggle/input/fitbit/Fitabase Data 4.12.16-5.12.16/hourlySteps_merged.csv")
```

Data taken from [link](https://www.kaggle.com/datasets/arashnic/fitbit)

### Exploring the data

```{r}
n_distinct(daily_activity$Id)
n_distinct(daily_sleep$Id)
n_distinct(daily_steps$Id)
n_distinct(daily_intensities$Id)
n_distinct(calories_per_day$Id)
n_distinct(calories_per_hour$Id)
n_distinct(hourly_intensities$Id)
n_distinct(hourly_steps$Id)
```
This code chunk shows the amount of users in each data set

Every set except 2nd has 33 users, so each data frame could be significant

### Formatting the dates in data sets for better interaction between them

```{r}
hourly_intensities$ActivityHour=as.POSIXct(hourly_intensities$ActivityHour, format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone())
hourly_intensities$time <- format(hourly_intensities$ActivityHour, format = "%H:%M:%S")
hourly_intensities$date <- format(hourly_intensities$ActivityHour, format = "%m/%d/%y")

names(daily_activity)[2] <- "Date"
daily_activity$Date=as.POSIXct(daily_activity$Date, format="%m/%d/%Y", tz=Sys.timezone())

names(daily_sleep)[2] <- "Date"
daily_sleep$Date=as.POSIXct(daily_sleep$Date, format="%m/%d/%Y", tz=Sys.timezone())
```


### Watching the summary of each data set

```{r}
daily_activity %>% 
  select(TotalDistance, VeryActiveDistance, ModeratelyActiveDistance, LightActiveDistance, Calories) %>%
  summary()

daily_sleep %>%
  select(TotalMinutesAsleep, TotalTimeInBed) %>%
  summary()

daily_steps %>% 
  select(StepTotal) %>% 
  summary()

daily_intensities %>% 
  select(SedentaryMinutes, LightlyActiveMinutes, FairlyActiveMinutes, VeryActiveMinutes) %>%
  summary()

calories_per_day %>% select(Calories) %>% summary()
```

#### Results of summary:

* Most of the distance is light active
* It takes 40 minutes to fall asleep for user, 7 hours of sleep per day. **So there could be notification for user to go asleep**
* The amount of sedentary minutes is enormous. Average is more than 16 hours. **Could be reduced by notification to make some exercises**
* The amount of fairly active minutes and distance is the lowest

#### According to medical research making 8000  steps in a day decrease the chance of any mortal case by 51% so I will check how many days are making more and less than average steps which is 7638 and 8000

```{r}
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
```

* In most of the days steps are below average and 8000

### Try to chek same data but per user
##### Create new data frame to see average steps per user

```{r}
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
```

* As we can see 15 users are above average and only 14 making more than 8000 steps a day


### I will merge 2 datasets daily sleep and activity for future visualisation

```{r}
merged_sleep_and_activity <- merge(daily_sleep, daily_activity, by=c('Id', 'Date'))
head(merged_sleep_and_activity)
```

### Visualisations

#### Most active hours

```{r, warning=FALSE}
#preparing data for plotting
intensities_plot <- hourly_intensities %>%
  group_by(time) %>%
  drop_na() %>%
  summarise(mean_intensities = mean(TotalIntensity))

ggplot(data = intensities_plot, mapping = aes(x = time, y = mean_intensities)) + geom_histogram(stat = "identity", fill = 'blue') + 
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title="Average Total Intensity vs. Time")
```

* **Time between 17:00 and 20:00 are the most active.** I suppose that users are going to the gym or having a training this time. **There could be a notification to go for training for motivation.**

#### Steps and calories

```{r}
ggplot(data=daily_activity, aes(x=TotalSteps, y=Calories)) + 
  geom_point() + geom_smooth() + labs(title="Steps vs. Calories")
```

* There is a positive correlation between Total Steps and Calories, the more active users are, the more calories they burn. **So if they want to lose some calories Bellabeat app could motivate them to do more steps**

#### Sedentary time and Sleeping time

```{r}
ggplot(data = merged_sleep_and_activity, mapping = aes(x = TotalMinutesAsleep, y = SedentaryMinutes)) + 
  geom_smooth() + 
  geom_point()
  labs(title = "Sleeping time vs Sedentary time")
```

* There is a negative correlation between Sedentary Minutes and Sleep time. **As opportunity: if Bellabeat users want to improve their sleep, Bellabeat app can recommend reduce sedentary time.**


### Recommendations for the buisness

#### After analyzing FitBit Fitness Tracker Data, I found some insights that would help influence Bellabeat marketing strategy.

#### Ideas for Bellabeat app:

![](https://martech.org/wp-content/uploads/2015/11/idea_1920-800x600.jpg)

* Average total steps per day are 7638 which a little bit less for having health benefits. Bellabeat can encourage users to take at least 8 000 explaining the benefits for their health.

* If users want to improve their sleep, Bellabeat should consider using app notifications to go to bed.

* As an idea: if users want to improve their sleep, the Bellabeat app can recommend reducing sedentary time.

* If users want to lose weight, it’s probably a good idea to control daily calorie consumption. Bellabeat can suggest to do more steps or exercises.

* Time between 17:00 and 20:00 are the most active. There could be a notification to go for training for motivation.

* Average sedentary time is more than 16 hours. Could be reduced by notification to make some exercises.

#### Target the audience

![](https://surveysparrow.com/wp-content/uploads/2021/07/How-to-define-and-find-target-audience-for-survey.jpg)

Women who work full-time jobs (according to the hourly intensity data) and spend a lot of time sitting at the office focused on work they are doing (according to the sedentary time data), that are interested to change their lifestyle to more active or lose weight and improve their sleep

#### The key message

Bellabeat should focus on being as a motivator and coach for its users to show them the way to the healthy and active life. Its app should motivate to do some stretches after long sedentary time or send a notification to go asleep for better well being.


