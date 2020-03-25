library(tidyverse)
library(dplyr)

address_raw <- read_csv("data/phone_numbers.csv")

gather_numbers <- address_raw %>% 
  gather(contact_type, Contact_number,Telephonenumber,Comm.No.1, Comm.No.2, Comm.No.3, Comm.No.4, Comm.No.5,
         Comm.No.6) %>% 
  select(-Comm.Type1, -Comm.Type2, -Comm.Type3, -Comm.Type3, -Comm.Type4, -Comm.Type5, -Comm.Type6, -`Issue Description`)
         