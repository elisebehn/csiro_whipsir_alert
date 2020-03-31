library(tidyverse)
library(dplyr)

address_raw <- read_csv("data/phone_numbers.csv")

gather_numbers <- address_raw %>% 
  gather(contact_type, Contact_number,Telephonenumber,Comm.No.1, Comm.No.2, Comm.No.3, Comm.No.4, Comm.No.5,
         Comm.No.6) %>% 
  select(-Comm.Type1, -Comm.Type2, -Comm.Type3, -Comm.Type3, -Comm.Type4, -Comm.Type5, -Comm.Type6, -`Issue Description`)
         
spread_data <- gather_numbers %>% 
  mutate(grouped_id = row_number()) %>% 
  spread(Addresstype, Contact_number) %>% 
  select(-grouped_id)

group <- spread_data %>% 
  group_by(EmpNo) %>% 
  summarise_each(funs(sum(., na.rm = TRUE)))

clean_data <- spread_data %>% 
  rename(contact_1 = "1", contact_2 = "2") %>% 
  filter(contact_1 == "Na" & contact_2 == "Na")






write_csv(spread_data, path = "processed_data/contact_numbers.csv")
