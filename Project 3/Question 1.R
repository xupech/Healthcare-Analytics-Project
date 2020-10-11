library(sandwich)
library(plm)
library(lmtest)
library(stargazer)
library(tidyverse)
library(knitr)
library(car)
library(readr)
library(dplyr)

vted16 <- read.table("~/Desktop/brandeis graduate school/Academics/2019 FALL/HS 256 Healthcare analytics/Third Assignment/VTED16.txt", header=TRUE, sep = ',')
View(vted16)
id507033<-vted16%>%filter(UNIQ==507033)

vtinp16 <- read.table("~/Desktop/brandeis graduate school/Academics/2019 FALL/HS 256 Healthcare analytics/Third Assignment/VTINP16_upd.txt", header=TRUE, sep = ',')
View(vtinp16)
inpatient507033<-vtinp16%>%filter(UNIQ==507033)
write.csv(inpatient507033, file = "~/Downloads/inpatient507033.csv")

vtoutp16 <- read.table("~/Desktop/brandeis graduate school/Academics/2019 FALL/HS 256 Healthcare analytics/Third Assignment/VTOUTP16.txt", header=TRUE, sep = ',')
View(vtoutp16)
outpatient507033<-vtoutp16%>%filter(Uniq==507033)


vtrevcode16 <- read.table("~/Desktop/brandeis graduate school/Academics/2019 FALL/HS 256 Healthcare analytics/Third Assignment/VTREVCODE16.txt", header=TRUE, sep = ',')
View(vtrevcode16)

rev507033<-vtrevcode16%>%filter(Uniq==507033)
write.csv(rev507033, file = "~/Downloads/rev507033.csv")