library(tidyverse)
library(dplyr)

#script for response team

stage_two <- read_csv("data/stage_two_phone_calls.csv")
sap_data <- read_csv("data/SAP_CONTACTINFO.CSV")

response_mapped <- stage_two %>% 
  select("AdditionalTeamName", "FirstName","LastName","Last Updated Time", "Created Time", "Message Subject",  "Message Sent Time",
         "Response Channel", "Voice Sent Time", "Voice Received Time", "Voice Acknowledged Time", "Response" )

no_response_filter <- filter(response_mapped, is.na(Response))

Join_to_sap <- left_join(sap_data,no_response_filter, by = c ("Ident" = "AdditionalTeamName"))

final_filter <- filter(Join_to_sap, FirstName != "NA")

data_for_HR_action <- Join_to_sap %>% 
  mutate(Number = 1:n()) %>% 
  select(Number, everything()) %>% 
  mutate(comments = " ")




write_csv(final_filter, path = "processed_data/final_Data_for_response_Team.csv")
