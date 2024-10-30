library(dplyr)
library(sf)

tmp <- sf::st_read("D:/GIS/Flickr/OrigFlickr.shp")
fires <- st_read("C:/Users/dbvanber/Downloads/S_USA.MTBS_BURN_AREA_BOUNDARY/S_USA.MTBS_BURN_AREA_BOUNDARY.shp")
join <- tmp %>% sf::st_join(fires[,1:6])

# Assume your dataframe is called 'df' and the date column is 'date_column'
# Also, specify the target date for classification

join <- join %>%
  mutate(dateFire = as.Date(paste(YEAR, STARTMONTH, STARTDAY, sep = "-"), format = "%Y-%m-%d"), date = as.Date(as.POSIXct(dateupload, origin="1970-01-01", tz="UTC")))


join$dateFire <- as.Date(join$dateFire)  # Replace with your target date

# Classify the rows based on the date
join <- join %>%
  mutate(classification = case_when(
    date >= dateFire - 7 & date < dateFire ~ "One week before",
    date > dateFire & date <= dateFire + 7 ~ "One week after",
    date == dateFire ~ "Target date",
    TRUE ~ "Outside range"
  ))

join <- join[c("field_1", "X", "dateupload", "date", "id", "latitude", "longitude", "owner", "tags", "title", "url_sq", "FIRE_ID", "FIRE_NAME", "YEAR", "STARTMONTH", "STARTDAY",  "dateFire", "FIRE_TYPE", "classification", "geometry")]


