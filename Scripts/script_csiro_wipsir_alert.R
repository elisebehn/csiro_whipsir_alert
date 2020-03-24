library(tidyverse)
whip_sir_data <- read_csv("data/raw_report_of_voice_calls.csv")
sap_data <- read_csv("data/SAP_CONTACTINFO.csv")


#This Script is used to pull togther data provied from the CSIRO WHipsir system and SAP system to 
#help coordinate the data for use in the responce for the HR Emergency Response Team 


#The Employee Ident will be used to join the two data sets togther, the data for both should be saved into the data folder.
#The spinifex report should be run as soon as the data is recieved by the Emergency repsonse team. Both data sets should be saved into CSV format.

#combined the data from both datasets using the employee ident - using a left join to combine the data

#Columns to be used from whipsir include (AdditionalTeamName, Last Updated Time, Created Time, Message Subject,  Message Sent Time
#Response Channel, Voice Sent Time, Voice Received Time, Voice Acknowledged Time, Response )


clean <- left_join(whip_sir_data, sap_data, by = c ("AdditionalTeamName" = "Ident"))

# next will need to select the columns we wish to use out of all the data.