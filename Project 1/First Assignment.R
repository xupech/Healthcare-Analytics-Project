library("ggplot2")
library("maps")
library("dplyr")

entity2<-npidata%>%filter(npidata$`Entity Type Code`==2)
mri<-entity2%>%filter(entity2$`Healthcare Provider Taxonomy Code_1`=='261QM1200X')
mri1<-mri%>%filter(mri$`Provider Business Practice Location Address State Name`!='GU'&mri$`Provider Business Practice Location Address State Name`!='PR')

x<-count(mri1, `Provider Business Practice Location Address State Name`, sort=TRUE)
population<-c(21299325,28701845,39557045,12741080,8908520,9995915,19542209,11689442,6902149,5611179,4659978,12807060,10519475,6042718,6691878,3943079,7171646,4887871,5695564,6126452,3013825,10383620,6770010,8517685,5813568,7535591,4468402,3156145,3572665,1356458,4190713,5084127,2986530,2095428,2911505,1929268,1754208,1338404,3034392,577737,967171,1062305,760077,3161105,737438,1057315,702455,1420491,882235,626299,1805832)
x$population<-population