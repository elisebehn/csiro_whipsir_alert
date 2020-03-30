library(tidyverse)


whip_sir_data <- read_csv("data/raw_report_of_voice_calls.csv")
sap_data <- read_csv("data/SAP_CONTACTINFO.CSV")


#This Script is used to pull togther data provied from the CSIRO WHipsir system and SAP system to 
#help coordinate the data for use in the responce for the HR Emergency Response Team 


#The Employee Ident will be used to join the two data sets togther, the data for both should be saved into the data folder.
#The spinifex report should be run as soon as the data is recieved by the Emergency repsonse team. Both data sets should be saved into CSV format.

#combined the data from both datasets using the employee ident - using a left join to combine the data

#Columns to be used from whipsir include (AdditionalTeamName, Last Updated Time, Created Time, Message Subject,  Message Sent Time
#Response Channel, Voice Sent Time, Voice Received Time, Voice Acknowledged Time, Response )

whipsir_cut <- whip_sir_data %>% 
  select(AdditionalTeamName,"FirstName",	"LastName", "Last Updated Time", "Created Time", "Message Subject",  "Message Sent Time",
         "Response Channel", "Voice Sent Time", "Voice Received Time", "Voice Acknowledged Time", "Response" )



clean <- left_join(sap_data, whipsir_cut, by = c ("Ident" = "AdditionalTeamName"))

data_for_HR_RT <- clean %>% 
  mutate(row_id = 1:n()) %>% 
  select(row_id, everything()) %>% 
  mutate(Comments = " ") %>% 
  filter(!is.na(FirstName))




rename(AdditionalTeamName = EmployeeIdent)

  write_csv(clean, "data/combinedreport.csv")
  