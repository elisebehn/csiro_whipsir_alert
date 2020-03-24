library(tidyverse)
library(dplyr)

whip_sir_data <- read_csv("data/raw_report_of_voice_calls.csv")
sap_data <- read_csv("data/SAP_CONTACTINFO.CSV")



whipsir_cut2 <- whip_sir_data %>% 
  mutate(whip_sir_data, row_num = rownames(whip_sir_data)) %>%
  select("AdditionalTeamName", "Last Updated Time", "Created Time", "Message Subject",  "Message Sent Time",
         "Response Channel", "Voice Sent Time", "Voice Received Time", "Voice Acknowledged Time", "Response", "row_num" ) %>% 
    select(row_number, everything())

clean2 <- left_join(whipsir_cut2, sap_data, by = c ("AdditionalTeamName" = "Ident"))

