
# tomorrow morning i will be adding in a possible state filter for data




library(tidyverse)



stage_one <- read_csv("data/stage_one_sms.csv")
sap_data <- read_csv("data/SAP_CONTACTINFO.CSV")
stage_two <- read_csv("data/stage_two_phone_calls.csv")


stage_one_cut <- stage_one %>% 
 select("AdditionalTeamName","FirstName",	"LastName",
         "Last Updated Time",	"Created Time",	"Message Label","Message Subject"	,
         "Message Sent Time","Voice Sent Time")



#incorporate SAP data to joined data set with contact details
combined_data <- full_join(sap_data,stage_one_cut, by = c ("Ident" = "AdditionalTeamName"))

remove_duplicate <- combined_data[!duplicated(combined_data$Ident),]


missing_from_whisper <- filter(remove_duplicate, is.na(FirstName))

missing_from_SAP <- filter(remove_duplicate, is.na(Surname))




filter_response_stage_1 <- filter(stage_one, !is.na(Response)) %>% 
  mutate(responded = "stage 1") %>% 
  mutate(Response = as.numeric(Response))


filter_response_stage_2 <- filter(stage_two, !is.na(Response)) %>% 
  mutate(responded = "stage 2")


people_who_responded <- bind_rows(filter_response_stage_1,filter_response_stage_2) %>% 
  mutate(Response_received = "yes") %>% 
  select("AdditionalTeamName","responded","Response_received")


remove_dup_test <- people_who_responded[!duplicated(people_who_responded$AdditionalTeamName),]

stage_one_slice <- stage_one %>% 
  select("AdditionalTeamName","FirstName",	"LastName",
         "Last Updated Time",	"Created Time",	"Message Label","Message Subject"	,
         "Message Sent Time","Voice Sent Time")



results_from_whispir_both_stages <- left_join(stage_one_slice, remove_dup_test, by = c ("AdditionalTeamName"))



Response_team_report <- left_join(sap_data,results_from_whispir_both_stages, by = c ("Ident" = "AdditionalTeamName"))%>% 
  filter(is.na(Response_received)) #%>% 



  Response_team_report2 <- Response_team_report %>%   
  select(-"responded", -"Response_received") %>% 
  mutate(Row_ID = 1:n()) %>% 
  select(Row_ID, everything()) %>% 
  mutate(comments = (ifelse(is.na(FirstName),"not picked up by Whispir", ""))) %>% 
  rename (Employee_Subgroup = 'Employee Subgroup') %>% 
  filter(Employee_Subgroup != 'ATNF User') %>% 
  select(-FirstName, - LastName)

  #Last 2 steps above I added a filter to remove ATNF Users#




all_data <- left_join(sap_data,results_from_whispir_both_stages, by = c ("Ident" = "AdditionalTeamName")) %>% 
  mutate(outcome = case_when(is.na(FirstName) ~ "Not Picked up by Whispir",
                             is.na(Surname) ~ "Missing from SAP",
                             responded == "stage 1" ~ "Responded to Text",
                             responded == "stage 2" ~ "Responded to Voicemail",
                             is.na(responded) & !is.na(FirstName) ~ "No Response",
                             TRUE ~ "Other")) 
  
summary <- all_data %>% 
  group_by(`State (Workplace)`, outcome) %>% 
  summarise(Headcount =n()) %>% 
spread(key = outcome, value = Headcount, fill = "" )  

test = createworkbook()


write_csv(summary, path = "processed_data/summary.csv")    
write_csv(all_data, path = "processed_data/all_results_with_sap.csv")  
write_csv(Response_team_report2, path = "processed_data/Final_Data_for_response_Team.csv")
write_csv(remove_duplicate, path = "processed_data/Final_data_output_all_data.csv")
write_csv(missing_from_whisper, path = "processed_data/Final_data_missing_from_whispir.csv")
write_csv(missing_from_SAP, path = "processed_data/Final_data_missing_from_sap.csv")



#Actions from here- format the Final_Data_for_response_Team in excel- where phone numbers exit change column format to numeric, zero decimal
#so you dont see exponential numbers. Bold the header. Send to Agnese. Check the missing from sap extract- these should all be ceased.

