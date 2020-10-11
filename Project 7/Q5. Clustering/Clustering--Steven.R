#rm(list = ls())
#gc()
set.seed(123456)
install.packages("openxlsx")
install.packages("cluster")
library(openxlsx)
library(stats)
library(dplyr)
library(cluster)
library(ggplot2)
library(hablar)
library(shiny)
library(plotly)
#sp500_companies = read.xlsx('./hello.xlsx')
#summary(sp500_companies)
#sp500_companies[is.na(sp500_companies$rentention) == TRUE,]
#sp500 <- sp500_companies %>%
#  select(Symbol, -Security,GICS.Sector, GICS.Sub.Industry, MC2.14,MC3.23, SP2.14, SP3.23)
#summary(sp500)

sp500 = read.csv('./sp500-data(with rv).csv')
# k means clustering
fit_kmeans <- kmeans(sp500$value_retention, 3) # k means clustering
fit_kmeans
fit_kmeans$centers # find out the centers of three clusters
result_kmeans = as.data.frame(fit_kmeans$cluster)
tb_result_kmeans = table(result_kmeans)
names(tb_result_kmeans) = c("HVR","LVR", "MVR") # define the groups as high, low, medium
tb_result_kmeans
sp500_kmeans = cbind(sp500, fit_kmeans$cluster)

#names(p8_0)[names(p8_0) == "Area"] <- "area"
names(sp500_kmeans)[names(sp500_kmeans)=='fit_kmeans$cluster'] <- 'cluster'

sp500_kmeans<-sp500_kmeans %>%
  convert(fct(cluster))
sp500_kmeans <- within(sp500_kmeans, cluster[cluster == 1] <- 'LVR')
sp500_kmeans <- within(sp500_kmeans, cluster[cluster == 2] <- 'HVR')
sp500_kmeans <- within(sp500_kmeans, cluster[cluster == 3] <- 'MVR')

# k median clustering
fit_kmedians = pam(sp500$value_retention,3) # k median clustering
results_kmedians = as.data.frame(fit_kmedians$clustering)
tb_result_kmedians = table(results_kmedians)
fit_kmedians$medoids  # find out the medoids of three clusters
names(tb_result_kmedians) = c("HVR","MVR","LVR") # define the groups as high, medium, low
tb_result_kmedians
sp500_kmedians = cbind(sp500, fit_kmedians$clustering)

names(sp500_kmedians)[names(sp500_kmedians)=='fit_kmedians$clustering'] <- 'cluster'

sp500_kmedians<-sp500_kmedians %>%
  convert(fct(cluster))
sp500_kmedians<-sp500_kmedians %>%
  convert(fct(GICS.Sector))

sp500_kmedians <- within(sp500_kmedians, cluster[cluster == 1] <- 'HVR')
sp500_kmedians <- within(sp500_kmedians, cluster[cluster == 2] <- 'MVR')
sp500_kmedians <- within(sp500_kmedians, cluster[cluster == 3] <- 'LVR')

# Since the smallest group of kmeans is 109 and that of kmedians is 103, we use kmeans in this case.
# kmedians_company_group$category = as.factor(case_when(kmedians_company_group$`fit_kmedians$cluster` == 1~"HVR", kmedians_company_group$`fit_kmedians$cluster` == 2~"MVR", kmedians_company_group$`fit_kmedians$cluster` == 3~"LVR"))
sp500_kmedians$index = 1:nrow(sp500_kmedians)

p1 <- ggplot(sp500_kmedians, aes(x=index, y=value_retention))
p1+geom_point(aes(colour = factor(GICS.Sector), shape = factor(cluster)))

ct1<- crosstab(sp500_kmedians, row.vars = 'GICS.Sector', col.vars = "cluster", type = "f")
write.csv(ct1$table,"ct1.csv")

ct2<- crosstab(sp500_kmedians, row.vars = 'GICS.Sector', col.vars = "cluster", type = "r")
write.csv(ct2$table,"ct2.csv")
