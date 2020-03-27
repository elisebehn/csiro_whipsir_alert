#script is combining the data from stage one and SAP
#this currently has muliple records for each employee
#another scritp will be produced for the response team to use for those who did not respond

library(tidyverse)


stage_one <- read_csv("data/stage_one_sms.csv")
sap_data <- read_csv("data/SAP_CONTACTINFO.CSV")
stage_two <- read_csv("data/stage_two_phone_calls.csv")


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

#********************************

Grab_data_stage_one <- stage_one %>% 
  select("AdditionalTeamName","Response")

Grab_data_stage_two <- stage_two %>% 
  select("AdditionalTeamName","Response")

final_response_both_stages <- full_join(Grab_data_stage_one, Grab_data_stage_two, by =c ("AdditionalTeamName"))
                                          
                                      
filter_final_response <- filter(final_response_both_stages, is.na(Response.x), is.na(Response.y)) %>% 
  mutate(include = "yes")

#************************************

response <- stage_two %>% 
  select("AdditionalTeamName", "Last Updated Time", "Created Time", "Message Subject",  "Message Sent Time",
         "Response Channel", "Voice Sent Time", "Voice Received Time", "Voice Acknowledged Time", "Response" )

include_filtered <- full_join(response,filter_final_response, by = c("AdditionalTeamName")) %>% 
  select("AdditionalTeamName", "Last Updated Time", "Created Time", "Message Subject",  "Message Sent Time",
         "Response Channel", "Voice Sent Time", "Voice Received Time", "Voice Acknowledged Time", "include" )


no_response <- filter(include_filtered, include == "yes")

cleaned <- left_join(no_response, sap_data, by = c ("AdditionalTeamName" = "Ident"))

remove_duplicates_no_response <- cleaned[!duplicated(cleaned$AdditionalTeamName),]

data_for_HR <- remove_duplicates_no_response %>% 
  rename(EmployeeIdent = AdditionalTeamName) %>% 
  mutate(Row_ID = 1:n()) %>% 
  select(Row_ID, everything()) %>% 
  mutate(comments = " ")

sort_hr_data <- data_for_HR [c(1,2,12:43,3:11)]




write_csv(sort_hr_data, path = "processed_data/Final_Data_for_response_Team.csv")
write_csv(remove_duplicate, path = "processed_data/Final_data_output_all_data.csv")
write_csv(missing_from_whisper, path = "processed_data/Final_data_missing_from_whispir.csv")
write_csv(missing_from_SAP, path = "processed_data/Final_data_missing_from_sap.csv")




#******************************************

#playing with Summary generation

whisper_stage_One_Summary <- 
