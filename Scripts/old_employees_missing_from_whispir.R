#script is combining the data from stage one and SAP
#script is used to check what employees are in SAP 
#that were not part of the Whisper output

library(tidyverse)


stage_one <- read_csv("data/stage_one_sms.csv")
sap_data <- read_csv("data/SAP_CONTACTINFO.CSV")


#select only useful information from stage one data
stage_one_cut_check <- stage_one %>% 
  select("AdditionalTeamName","FirstName",	"LastName",
         "Last Updated Time",	"Created Time",	"Message Label",	"Message Subject"	,
         "Message Sent Time",	"Response Channel"	,"SMS Sent Time",
         "SMS Received Time"	,"SMS Acknowledged Time"	,"SMS Undeliverable Time",
         "Voice Sent Time",	"Voice Received Time"	,"Voice Acknowledged Time",	
         "Voice Undeliverable Time"	,"Web Sent Time",	"Response")


#incorporate SAP data to joined data set with contact details
combined_data_check <- left_join(sap_data,stage_one_cut_check, by = c ("Ident" = "AdditionalTeamName"))

#filter to show only those employees who were skipped in whispir alert report
missing_from_whisper <- filter(combined_data_check, is.na(FirstName))

#writting to file 
write_csv(missing_from_whisper, path = "processed_data/Final_output_missing_from_whispir.csv")
