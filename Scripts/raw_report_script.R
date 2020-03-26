#script is cobining the data from stage one and stage 2 raw files
#and then adding in the updated SAP contact info
#this currently has muliple records for each employee
#another scritp will be produced for the response team to use for those who did not respond

library(tidyverse)
library(dplyr)

stage_one <- read_csv("data/stage_one_sms.csv")
stage_two <- read_csv("data/stage_two_phone_calls.csv")
sap_data <- read_csv("data/SAP_CONTACTINFO.CSV")

#change response column to numeric so data binds
stage_one_clean <- stage_one %>% 
  mutate(Response = as.numeric(Response))

#bind data from stage one and two 
joined_data <- bind_rows(stage_two,stage_one_clean)

#select only useful information from these data sources
stage_one_and_two_cut <- joined_data %>% 
  select("AdditionalTeamName",	"Last Updated Time",	"Created Time",	"Message Label",	"Message Subject"	,
         "Message Sent Time",	"Response Channel"	,"SMS Sent Time",
        "SMS Received Time"	,"SMS Acknowledged Time"	,"SMS Undeliverable Time",
          "Voice Sent Time",	"Voice Received Time"	,"Voice Acknowledged Time",	
        "Voice Undeliverable Time"	,"Web Sent Time",	"Response")

#add row label- not sure if we need thisin this data set
stage_row_labeled <- mutate(stage_one_and_two_cut, row_num = rownames(stage_one_and_two_cut))

#incorporate SAP data to joined data set with contact details
combined_data <- left_join(stage_row_labeled, sap_data, by = c ("AdditionalTeamName" = "Ident"))


#relable Ident column
change_to_ident <- combined_data %>% 
  rename(Ident = AdditionalTeamName)

#put numbered column at front
orderd <- change_to_ident %>% 
  select(row_num, everything())

write_csv(spread_data, path = "processed_data/all_data_stage_1_2s.csv")
