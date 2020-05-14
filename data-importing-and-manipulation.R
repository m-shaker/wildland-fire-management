
# Data importing and manipulation


#Reading the data
data = read.csv('cleaned_data.csv')

#Feature selection
interesting_features = c('FFMC','DMC','DC','ISI','BUI','FWI',
                         'FUEL_TYPE','RATEOFSPREAD','EST_DISC_SIZE',
                         'GENERAL_CAUSE','GENERAL_IGN',
                         'RESP_GROUP')

#Dataframe with selected features
library(dplyr)
df = select(data,interesting_features)

#Number of rows in the data
data_length = nrow(data)

#Generating an id for each entry 
id <- c(1:data_length) %>% factor()

#Adding id for original data
data$id <- id

#Making a new dataframe to convert all strings to factors
converted_df <- data.frame(id, df$FFMC, df$DMC, df$DC, df$ISI, df$BUI, df$FWI, df$FUEL_TYPE, df$RATEOFSPREAD, df$EST_DISC_SIZE, df$GENERAL_CAUSE, df$GENERAL_IGN, df$RESP_GROUP)
