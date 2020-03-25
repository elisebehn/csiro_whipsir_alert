library(tidyverse)
library(dplyr)

whip_sir_data <- read_csv("data/raw_report_of_voice_calls.csv")
sap_data <- read_csv("data/SAP_CONTACTINFO.CSV")



whipsir_cut2 <- whip_sir_data %>% 
select("AdditionalTeamName", "Last Updated Time", "Created Time", "Message Subject",  "Message Sent Time",
       "Response Channel", "Voice Sent Time", "Voice Received Time", "Voice Acknowledged Time", "Response")


whisper <- mutate(whipsir_cut2, row_num = rownames(whipsir_cut2))
  

clean2 <- left_join(whisper, sap_data, by = c ("AdditionalTeamName" = "Ident"))

change_name <- clean2 %>% 
  rename(Ident = AdditionalTeamName)

orderd <- change_name %>% 
  select(row_num, everything())



