library(tidyverse)
library(dplyr)

stage_one <- read_csv("data/stage_one_sms.csv")
stage_two <- read_csv("data/stage_two_phone_calls.csv")
sap_data <- read_csv("data/SAP_CONTACTINFO.CSV")

stage_one_clean <- stage_one %>% 
  mutate(Response = as.numeric(Response))
  
joined_data <- bind_rows(stage_two,stage_one_clean)

stage_one_and_two_cut <- joined_data %>% 
  select("AdditionalTeamName",	"Last Updated Time",	"Created Time",	"Message Label",	"Message Subject"	,
         "Message Sent Time",	"Response Channel"	,"SMS Sent Time",
        "SMS Received Time"	,"SMS Acknowledged Time"	,"SMS Undeliverable Time",
          "Voice Sent Time",	"Voice Received Time"	,"Voice Acknowledged Time",	
        "Voice Undeliverable Time"	,"Web Sent Time",	"Response")

stage_row_labeled <- mutate(stage_one_and_two_cut, row_num = rownames(stage_one_and_two_cut))

combined_data <- left_join(stage_row_labeled, sap_data, by = c ("AdditionalTeamName" = "Ident"))

change_to_ident <- combined_data %>% 
  rename(Ident = AdditionalTeamName)

orderd <- change_to_ident %>% 
  select(row_num, everything())
