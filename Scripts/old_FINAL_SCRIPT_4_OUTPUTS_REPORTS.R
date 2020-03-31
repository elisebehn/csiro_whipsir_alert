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



#TRYING TO FIX THE FILTER FOR THE DATA WE PROVIDE TO HR REPSONSE TEAM

#********************************

filter_response_stage_2 <- filter(stage_two, !is.na(Response)) %>% 
  mutate(responded = "stage 2")
 
filter_response_stage_1 <- filter(stage_one, !is.na(Response)) %>% 
  mutate(responded = "stage 1") %>% 
  mutate(Response = as.numeric(Response))

people_who_responded <- bind_rows(filter_response_stage_1,filter_response_stage_2) %>% 
  mutate(Response_recieved = "yes") %>% 
  select("AdditionalTeamName","responded","Response_recieved")

remove_dup_test <- people_who_responded[!duplicated(people_who_responded$AdditionalTeamName),]

test_join <- left_join(sap_data,remove_dup_test, by = c ("Ident" = "AdditionalTeamName")) %>% 
  filter(is.na(Response_recieved))

results_from_whispir_both_stages <- left_join(stage_one_cut, remove_dup_test, by = c ("AdditionalTeamName"))

hr_response_team_file <- left_join(sap_data, results_from_whispir_both_stages, by = c ("Ident" = "AdditionalTeamName")) %>% 
  filter(is.na(Response_recieved))




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
