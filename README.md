# Visit Location Exports

This is a simple script that enables users to export visit locations that are produced from the processes described in [GPStoVists](https://github.com/todd-james/GPStoVisits/tree/main). The script takes a number of arguments that are detailed below. Users are able to get all the visit locations for users that visit a given area (determined by a bounding box) for the date range provided. The script produces a csv of those visits for each day in the date range. Users may consider my [simple shiny app](https://james-todd.shinyapps.io/VisitExploration/) to upload and explore individual user visit locations produced by this script. If you have data that do not in the EXACTLY the same format as the output from this script (specified below), then consider using my [other shiny app](https://james-todd.shinyapps.io/ExploreGPS/) to explore GPS data more generally and with no fixed format. 

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

# Requirements 
- R
	- sf 
	- lubridate 
	- dplyr 

# Detailed Instructions
1. Identify the dates that you are interested in.
2. Identify an area that you are interested in getting data from and get the appropriate bounding box for this area. I like to use [bboxfinder.com](bboxfinder.com)) to get these. On this site, you can simply draw a box for the area you are interested in and then copy the 4 coordinates in WGS84 [EPSG:4326] format on the bottom left of the page. 
3. Open Terminal (Max/Linux) or Powershell/Command Prompt (Windows) and navigate to the directory where you have saved the `ExportDailyUserVisitsWithinArea.R` file and associated `GRID6` files are also located. 
4. Run the following command with your input parameters: 
Mac/Linux:
`Rscript ExportDailyUserVisitsWithinArea.R <data_path> <start_date> <end_date> <min_lon> <min_lat> <max_lon> <max_lat> <prefix>`
Windows: 
`'C:\ProgramFiles\R\R.4.1\Rscript.exe' ExportDailyUserVisitsWithinArea.R <data_path> <start_date> <end_date> <min_lon> <min_lat> <max_lon> <max_lat> <prefix>`
5. Wait patiently until the process finishes and you have all files for each day between your requested start and end dates. 

Processes will take some time due to the fact that data are stored as csv and only segregated by month. As such, all the csv files have to be loaded in at first, and then the subsetting process begins. Should your requested data straddle multiple months (i.e. your start and end date are not in the same month/year combination), then please expect the subsetting process to take considerably longer given that another X months worth of data have to be read in. If you do run into issues, I would limit the start and end date to be within the same month and make multiple requests if you require additional data. 

# Outputs
The script will produce X number of csv files in the directory where the script is located. The number of csv files will depend on the number of days that are included in the requested date range. csv files will be in the format `<prefex>-<start_date>.csv ... <prefex>-<end_date>.csv`. 
Each csv will contain the following attributes: 
- <uuid> - Unique User ID 
- <start> - The datetime in which the visit commenced 
- <end> - The datetime in wich the visit ended
- <duration> - The duration of the visit
- \<GRID_CODE> - The Japanese mesh code ID at resolution 6 (125m)
- <X> - The Longitude coordinate of the visit 
- <Y> - The Latitude coordinate of the visit