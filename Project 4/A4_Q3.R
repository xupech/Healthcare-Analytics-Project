library(data.table)
library(readxl)
setwd("C://Grad//Healthcare//HW3")
inpatient = fread("VTINP16_upd.txt")
revcode = fread("VTREVCODE16.txt")
drg20_977 = inpatient[DRG >= 20 & DRG <= 977]
setnames(revcode, old = "Uniq", new = "UNIQ")
alldata = merge(drg20_977, revcode, by = "UNIQ", all.x = TRUE)
filter_charge = alldata[REVCHRGS >= 100]
#na.omitted, many NA values in PCCR column
delete_NA = na.omit(filter_charge, cols = c("PCCR", "DRG"), invert=FALSE)
newdata = delete_NA[, .(sum_charge = sum(REVCHRGS)), by = .(UNIQ, DRG, PCCR)]
fwrite(newdata, "newdata.csv")

#give pccr actual names
namePCCR = read_excel("REVCODE_FILE_LAYOUT_and_CODES.xls", sheet = "PCCR")
namePCCR$PCCR = as.integer(namePCCR$PCCR)
namePCCR = data.table(namePCCR)
#excludeNA = na.omit(newdata, cols = c("PCCR", "DRG"), invert=FALSE)
name_newdata = merge(x = newdata, y = namePCCR, by = "PCCR", all.x = TRUE)
name_newdata = name_newdata[, name := paste0(PCCR, sep = " ", PCCR_NAME )]
#calculate $ per DRG per PCCR

charge_per_pccr = name_newdata[, .(avg_charge = mean(sum_charge)), by = .(DRG, name)]
#make PCCRs as columns and rename columns by PCCR names

test = reshape(charge_per_pccr, idvar="DRG", timevar="name", direction="wide")
names(test) <- substring(names(test), 12)
colnames(test)[1] <- "DRG"

#set row names as DRG names
nameDRG = read_excel("FILE_LAYOUT_and_CODES.xls", sheet = "MSDRG 2007 forward")
colnames(nameDRG)[1] <- "DRG"
nameDRG$DRG = as.integer(nameDRG$DRG)
DRGsub = subset(nameDRG, select = c("DRG", "MSDRG_DESC"))
mydata = merge(x = DRGsub, y = test, by = "DRG", all.y = TRUE)

#create new column PCCR_OR_and_Anesth_Costs, set NA to 0 so we could calculate by the numbers
mydata = data.table(mydata)
mydata[is.na(mydata)] = 0
mydata$PCCR_OR_and_Anesth_Costs = mydata[, .(`3700 Operating Room` 
                 + `4000 Anesthesiology`)]


