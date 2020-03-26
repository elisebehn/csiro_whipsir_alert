library(tidyverse)
library(dplyr)

stage_one <- read_csv("data/stage_one_sms.csv")
stage_two <- read_csv("data/stage_two_phone_calls.csv")
sap_data <- read_csv("data/SAP_CONTACTINFO.CSV")

response <- stage_two %>% 
  select("AdditionalTeamName", "Last Updated Time", "Created Time", "Message Subject",  "Message Sent Time",
         "Response Channel", "Voice Sent Time", "Voice Received Time", "Voice Acknowledged Time", "Response" )

no_response <- response %>% 
  filter(Response != 2)

cleaned <- left_join(no_response, sap_data, by = c ("AdditionalTeamName" = "Ident"))

data_for_HR <- cleaned %>% 
  rename(EmployeeIdent = AdditionalTeamName) %>% 
  mutate(Number = 1:n()) %>% 
  select(Number, everything())

write_csv(spread_data, path = "processed_data/Data_for_response_Team.csv")
