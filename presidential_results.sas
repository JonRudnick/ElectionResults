/*
* authors: Andrew Dunne, Mahesh Gaya, Jonathan Rudnick
* description: visualization on presidential elections
* class: R and SAS
*/

/* TASK: Import CSV Data from the .csv file */
proc import
	datafile = "US_County_Level_Presidential_Results_12-16.csv"
	out = Presidential_Results_Old
	dbms = csv
	replace;
	getnames = YES;
	guessingrows = 100;
run;

/*Cleaning the data - Dropping unnecessary columns*/

data Presidential_Results(drop = combined_fips FIPS county_fips state_fips);
	set Presidential_Results_Old;
	run;

/*binning all of the necessary sections*/

data Presidential_Results;
set Presidential_Results;
length region $15 demWin2012 $3 demWin2016 $3 gopWin2012 $3 gopWin2016 $3 candidate_category $10;
	if state_abbr in ("TX","OK","AR","LA","MS","TN","KY","AL","FL","GA","SC","NC","VA","WV","DC","MD","DE")
		then region = "South";
	else if state_abbr in ("PA","NY","NJ","CT","RI","MA","VT","NH","ME")
		then region = "Northeast";
	else if state_abbr in ("ND","SD","NE","KS","MO","IA","MN","WI","IL","IN","MI","OH")
		then region = "Midwest";
	else if state_abbr in ("HI","AK")
		then region = "Pacific";
	else region = "West";

	if per_point_diff_2016 > 0 then candidate2016 = "Clinton";
	else candidate2016 = "Trump";

	if per_point_diff_2012 > 0 then candidate2012 = "Obama";
	else candidate2012 = "Romney";

run;

proc summary data = Presidential_Results print;
var _numeric_;
class total_votes_2016;
run;

proc summary data = Presidential_Results print;
class state_abbr;
run;

proc sgplot data=Presidential_Results;
	vbar region;
run;

proc sgplot data=Presidential_Results;
	histogram per_point_diff_2016;
run;

proc sgplot data=Presidential_Results;
	histogram per_point_diff_2012;
run;

proc sgplot data=Presidential_Results;
	vbox per_point_diff_2016 / category=region;
run;

proc sgplot data=Presidential_Results;
	vbox per_point_diff_2012 / category=region;
run;

proc freq data=Presidential_Results;
	tables candidate2016*region;
run;

proc freq data=Presidential_Results;
	tables candidate2012*region;
run;

proc means data=Presidential_Results;
	class state_abbr;
	var per_point_diff_2016;
run;
proc means data=Presidential_Results;
	class state_abbr;
	var per_point_diff_2012;
run;

proc summary data = Presidential_Results print;
var per_point_diff_2016;
class state_abbr;
run;
proc summary data = Presidential_Results print;
var per_point_diff_2012;
class state_abbr;
run;

proc sgplot data=Presidential_Results;
	scatter x=per_point_diff_2016 y=total_votes_2016 / group=candidate2016;
run;


proc sgplot data=Presidential_Results;
	scatter x=per_point_diff_2012 y=total_votes_2012 / group=candidate2012;
run;
