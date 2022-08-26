
# setting directory to access appropriate csv files
getwd()
setwd("/Users/joecookson/Desktop/Lab Project")

#reading and making changes to MDSC file

MDSC <- read.csv("RealDataMDSC.csv", stringsAsFactors=T)
head(MDSC)
colnames(MDSC)[2] <- c("RUN.DATE")
colnames(MDSC)[3] <- c("STUDY.NAME")
head(MDSC)
MDSC$STUDY.NAME <- gsub(" ", ".", MDSC$STUDY.NAME)
MDSC$STUDY.NAME[MDSC$STUDY.NAME == "Liver.TX"] <- "LIV.TX"
MDSC$STUDY.NAME

# reading and making changes to Treg file

Treg <- read.csv("RealDataTreg.csv", stringsAsFactors=T)
head(Treg)

# removing spaces in study name to merge more accurately
Treg$STUDY.NAME <- gsub(" ", ".", Treg$STUDY.NAME)
Treg$STUDY.NAME
Treg
# cleaning data 
Treg$STUDY.NAME[Treg$STUDY.NAME %in% "Liver.TX"] <- "LIV.TX"
Treg$STUDY.NAME

#creating new columns
head(Treg)
Treg$Lymph.CD3.Among.L <- round(Treg$CD3..AMONG.L * Treg$LYMPHS, 1)
Treg$LymphCD3.x.CD4 <- round(Treg$Lymph.CD3.Among.L * Treg$CD4..AMONG.CD3., 1)
Treg$CD4.x.TREG <- round(Treg$LymphCD3.x.CD4 * Treg$TREG.AMONG.CD4., 1)
Treg$LymphCD3.x.CD4.x.Treg <- NULL
head(Treg)
# work in progress below, need to reaffirm i am multiplying right things together
#Treg$BEADS <- ((Treg$CD3..AMONG.L / Treg$SINGLET) * (MDSC$N.L / 100)) * Dilution Value
head(Treg)
#converting to excel file and merging data frames

install.packages("writexl")
joined_df <- merge(Treg, MDSC, by=c("RUN.DATE", "PT.ID", "STUDY.NAME"), 
                   all=TRUE)

head(joined_df)
library("writexl")
#exported to new empty excel file
write_xlsx(joined_df,"/Users/joecookson/Desktop/Lab Project/FinalMerge.xlsx")
