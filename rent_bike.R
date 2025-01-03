getwd()
setwd('C:/Users/user/Desktop/portfolio/rent_bike')
getwd()

a <- read.csv('bike_2312.csv',header = TRUE, fileEncoding = "CP949", encoding = "UTF-8")
write.table(a, file = "rental_2312.csv", sep = '|', quote = FALSE, qmethod = "escape", row.names = FALSE)

b <- read.csv("rent_area_2312.csv", header = TRUE)
write.table(b, file = "area_2312.csv", sep = '|', quote = FALSE, qmethod = "escape", row.names = FALSE)
