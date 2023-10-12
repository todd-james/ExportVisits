# Visit Location Exports

This is a simple script that enables users to export visit locations that are produced from the processes described in [GPStoVists](https://github.com/todd-james/GPStoVisits/tree/main). The script takes a number of arguments that are detailed below. Users are able to get all the visit locations for users that visit a given area (determined by a bounding box) for the date range provided. The script produces a csv of those visits for each day in the date range. Users may consider using [this shiny app](https://james-todd.shinyapps.io/VisitExploration/) to upload and explore individual user visit locations produced by this script. 

# Requirements 
- R
	- sf 
	- lubridate 
	- dplyr 

# Use
`Rscript ExportDailyUserVisitsWithinArea.R <data_path> <start_date> <end_date> <min_lon> <min_lat> <max_lon> <max_lat> <prefix>`

NOTE: Argument order is important! 
1. <data_path> - file path to visit csv's 
2. <start_date> - starting date of requested data (%Y-%m-%d)
3. <end_date> - ending date of requested data (%Y-%m-%d)
4. <min_lon> - minimum longitude coordinate of bounding box
5. <min_lat> - minimum latitude coordinate of bounding box
6. <max_lon> - maximum longitude coordinate of bounding box
7. <max_lat> - maximum latitude coordinate of bounding box
8. \<prefix> - name of file prefix

# Outputs
The script will produce X number of csv files in the directory where the script is located. The number of csv files will depend on the number of days that are included in the requested date range. csv files will be in the format `<prefex>-<start_date>.csv ... <prefex>-<end_date>.csv`