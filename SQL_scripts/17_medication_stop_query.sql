# get a table of all rows of medication 17 in the therapy table
CREATE TABLE oliver.therapy_17_single_row AS
SELECT * FROM 17_205R_Providencia.therapy
WHERE bnfcode = 17;

# get a list of patients that recieve medication 17 at some point in their therapy
CREATE TABLE oliver.patids_17 AS
SELECT DISTINCT patid FROM oliver.therapy_17_single_row;

# add indexing in on eventdate in therapy_single_row

# get dates of first and last instances of 17 coded in the therapy data for this group of patients
CREATE TABLE oliver.eventdates_17 AS
SELECT patid, max(eventdate) AS max_eventdate_17, min(eventdate) AS min_eventdate_17
FROM oliver.therapy_17_single_row
GROUP BY patid;

# get date of last entry in therapy table for this list of patients
CREATE TABLE oliver.enddate_17 AS
SELECT t.patid, max(t.eventdate) AS max_eventdate
FROM 17_205R_Providencia.therapy AS t
INNER JOIN oliver.eventdates_17 AS s ON s.patid=t.patid
GROUP BY t.patid;

# join the eventdates and enddate tables and create a new flag:
	# 1 if last date of data entry more than 84 days after last date of medication 17
	# 0 if last date of medication 135 is within 84 days of last data entry
CREATE TABLE oliver.flags_17 AS
SELECT t.patid, s.min_eventdate_17, 
	   IF(s.max_eventdate_17 - INTERVAL 6 MONTH < s.min_eventdate_17, 
		  s.min_eventdate_17, s.max_eventdate_17 - INTERVAL 6 MONTH) AS max_eventdate_17_less_6_month,
	   s.max_eventdate_17, t.max_eventdate,
	   IF(t.max_eventdate > (s.max_eventdate_17 + INTERVAL 84 DAY), 1, 0) AS stopped_in_data
FROM oliver.enddate_17 AS t
INNER JOIN oliver.eventdates_17 AS s ON s.patid=t.patid;

#################################################################################################################

# this code is going straight in to command prompt on idhs server

# need clinical data from last instance of 17 to 84 days after AS clinical_17_max_84_after
# need clinical data from prior to 84 days after last instance of 17 to start AS clinical_17
# need therapy data for 84 days prior to first instance of 17 AS therapy_17_min_84_before
# need therapy data for 84 days prior to 6 months before the last instance of 17 AS therapy_17_max_6_mnth_84_before
# need flags data AS flags_17
# need patient data AS patient_17

SELECT s.* FROM oliver.flags_17 AS t
LEFT JOIN 17_205R_Providencia.therapy AS s
ON t.patid=s.patid
WHERE s.eventdate BETWEEN t.min_eventdate_17 - INTERVAL 84 DAY
					  AND t.min_eventdate_17 
INTO OUTFILE '/data/mysql-files/therapy_17_min_84_before.txt';

SELECT s.* FROM oliver.flags_17 AS t
LEFT JOIN 17_205R_Providencia.therapy AS s
ON t.patid=s.patid
WHERE s.eventdate BETWEEN t.max_eventdate_17_less_6_month - INTERVAL 84 DAY
					  AND t.max_eventdate_17_less_6_month 
INTO OUTFILE '/data/mysql-files/therapy_17_max_6_mnth_84_before.txt';


