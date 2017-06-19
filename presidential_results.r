# authors: Andrew Dunne, Mahesh Gaya, Jonathan Rudnick
# description: Visualization on presidential election
# class: R and SAS

# IMPORTANT: Please change the directory for the data
# Import data from csv file and put that into a table
presidential_results_old <- read.table("C:\\Users\\TEMP.DRAKE.000\\Downloads\\US_County_Level_Presidential_Results_12-16.csv",
                                   header = T, sep = ",", stringsAsFactors = F)

#Remove unnecessary columns
drop_columns <- names(presidential_results_old) %in% c("combined_fips", "FIPS", "county_fips", "state_fips")

presidential_results <- presidential_results_old[!drop_columns]

#Binning
#categorize the states into Northeast, South, Midwest, Pacific, and West
presidential_results$region<- ifelse( presidential_results$state_abbr %in%
  c("TX","OK","AR","LA","MS","TN","KY","AL","FL",
    "GA","SC","NC","VA","WV","DC","MD","DE"),
  "South",
  ifelse( presidential_results$state_abbr %in%
      c("PA","NY","NJ","CT","RI","MA","VT","NH","ME"),
    "Northeast",
    ifelse( presidential_results$state_abbr %in%
              c("ND","SD","NE","KS","MO","IA","MN","WI","IL","IN","MI","OH"),
            "Midwest",
            ifelse( presidential_results$state_abbr %in%
                      c("HI","AK"),
                    "Pacific",
                    "West")
    )
  )
)

#Who won in 2016?
presidential_results$candidate2016 <- ifelse(
  presidential_results$per_point_diff_2016 > 0,
  "Clinton", "Trump"
)

#Who won in 2012?
presidential_results$candidate2012 <- ifelse(
  presidential_results$per_point_diff_2012 > 0,
  "Obama", "Romney"
)

#distributional summary
summary(presidential_results)

#summary table
summary(presidential_results$state_abbr)

#bar chart
barplot(
  table(presidential_results$region),
  xlab = "Region"
)

#histogram
hist(
  presidential_results$per_point_diff_2016,
  breaks = 24,
  col = "dark red",
  main = "Histogram of Winning Percentage in 2016",
  xlab = "Win Percent"
)

#histogram
hist(
  presidential_results$per_point_diff_2012,
  breaks = 24,
  col = "dark blue",
  main = "Histogram of Winning Percentage in 2012",
  xlab = "Win Percent"
)

#boxplot
boxplot(
  per_point_diff_2016~region,
  data = presidential_results,
  col = c("dark green", "dark blue", "purple", "dark red", "grey"),
  main = "Winning Percentage by Region in 2016",
  xlab = "Region",
  ylab = "Win Percent"
)

#boxplot
boxplot(
  per_point_diff_2012~region,
  data = presidential_results,
  col = c("dark green", "dark blue", "purple", "dark red", "grey"),
  main = "Winning Percentage by Region in 2012",
  xlab = "Region",
  ylab = "Win Percent"
)

#cross-tab
mytable <- xtabs(~presidential_results$candidate2016+presidential_results$region, data=presidential_results)
ftable(mytable) # print table 
summary(mytable) # chi-square test of indepedence

#cross-tab
mytable <- xtabs(~presidential_results$candidate2012+presidential_results$region, data=presidential_results)
ftable(mytable) # print table 
summary(mytable) # chi-square test of indepedence

#mean
aggregate(presidential_results$per_point_diff_2016, by=list(presidential_results$state_abbr), FUN=mean)

#scatterplot
plot(
  presidential_results$per_point_diff_2016,
  presidential_results$total_votes_2016,
  main = "Total Votes by Winning Percentage",
  xlab = "Win Percent",
  ylab = "Total Votes"
)