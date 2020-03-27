#script is combining the data from stage one and SAP
#this currently has muliple records for each employee
#another scritp will be produced for the response team to use for those who did not respond

library(tidyverse)


stage_one <- read_csv("data/stage_one_sms.csv")
sap_data <- read_csv("data/SAP_CONTACTINFO.CSV")


#select only useful information from these data sources
stage_one_cut <- stage_one %>% 
  select("AdditionalTeamName","FirstName",	"LastName",
	"Last Updated Time",	"Created Time",	"Message Label",	"Message Subject"	,
         "Message Sent Time",	"Response Channel"	,"SMS Sent Time",
         "SMS Received Time"	,"SMS Undeliverable Time",
         "Voice Sent Time",	"Voice Received Time"	,"Voice Acknowledged Time",	
         "Voice Undeliverable Time"	,"Web Sent Time",	"Response")


#incorporate SAP data to joined data set with contact details
combined_data <- full_join(sap_data,stage_one_cut, by = c ("Ident" = "AdditionalTeamName"))

remove_duplicate <- combined_data[!duplicated(combined_data$Ident),]
  
missing_from_whisper <- filter(remove_duplicate, is.na(FirstName))
  
missing_from_SAP <- filter(remove_duplicate, is.na(Surname))


write_csv(remove_duplicate, path = "processed_data/Final_data_output_all_data.csv")
write_csv(missing_from_whisper, path = "processed_data/Final_data_missing_from_whispir.csv")
write_csv(missing_from_SAP, path = "processed_data/Final_data_missing_from_sap.csv")
