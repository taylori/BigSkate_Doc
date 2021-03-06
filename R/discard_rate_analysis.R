# load some WCGOP data from a few years ago
if(FALSE){
  load('C:/data/WCGOP/Observer_Catch_Data_2002_2015.Rdat')
  load('C:/data/WCGOP/Observer_Biological_Data_2002_2015.Rdat')
}

# list of all species
all_species <- unique(OBCatch$species)
# list of skate species
skate_species <- all_species[grep("skate", tolower(all_species))]

# subset big table to list of skate species
OBCatch_skates <- OBCatch[OBCatch$species %in% skate_species,]
# sum catch by species
total_MT  <- aggregate(OBCatch_skates$MT,  by=list(OBCatch_skates$species), FUN=sum)
total_RET_MT <- aggregate(OBCatch_skates$RET_MT, by=list(OBCatch_skates$species), FUN=sum)
total_DIS_MT <- aggregate(OBCatch_skates$DIS_MT, by=list(OBCatch_skates$species), FUN=sum)

# combine aggregated catch into 1 table
total_table <- data.frame(total_MT$Group.1, MT=total_MT$x,
                          RET_MT=total_RET_MT$x, DIS_MT=total_DIS_MT$x)
# round values
total_table[,-1] <- round(total_table[,-1])
# calculate discard rate
total_table$disc_rate <- round(total_table$DIS_MT / total_table$MT,2)

# print table ordered by total
total_table[order(total_table$MT, decreasing=TRUE),]

##             total_MT.Group.1   MT RET_MT DIS_MT disc_rate
## 8             Longnose Skate 5956   4458   1498      0.25
## 11                Skate Unid 3437   3044    393      0.11
## 4                  Big Skate  912    466    447      0.49
## 10           Sandpaper Skate  311      1    310      1.00
## 5                Black Skate  152      1    151      0.99
## 6           California Skate   61      1     59      0.97
## 2             Aleutian Skate   12      0     12      1.00
## 7              Deepsea Skate    4      0      4      1.00
## 12              Starry Skate    3      0      3      1.00
## 13               White Skate    1      0      1      1.00
## 1               Alaska Skate    0      0      0       NaN
## 3               Bering Skate    0      0      0       NaN
## 9  Roughshoulder/Broad Skate    0      0      0       NaN

# three groupings:
species == "Big Skate"
species %in% c("Big Skate", "Skate Unid")
species %in% c("Big Skate", "Skate Unid", "Longnose Skate")



dir.dis <- 'C:/SS/skates/discards/'
files <- dir(file.path(dir.dis, 'WCGOP discard rates'))

cs_3spec <- read.csv(file.path(dir.dis, 'WCGOP discard rates',
  "big longnose_unid_skates_OB_DisRatios_boot_cs_big_longnose_2019-04-26.csv"))
ncs_3spec <- read.csv(file.path(dir.dis, 'WCGOP discard rates',
  "big longnose_unid_skates_OB_DisRatios_boot_ncs_2019-04-26.csv"))
cs_2spec <- read.csv(file.path(dir.dis, 'WCGOP discard rates',
  "big skate_and_unid_OB_DisRatios_boot_cs_2019-04-26.csv"))
ncs_2spec <- read.csv(file.path(dir.dis, 'WCGOP discard rates',
  "big skate_and_unid_OB_DisRatios_boot_ncs_2019-04-26.csv"))
cs_1spec <- read.csv(file.path(dir.dis, 'WCGOP discard rates',
  "big skate_alone_OB_DisRatios_boot_cs_2019-04-26.csv"))
ncs_1spec <- read.csv(file.path(dir.dis, 'WCGOP discard rates',
  "big skate_alone_OB_DisRatios_boot_ncs_2019-04-26.csv"))


# examination of the data shows trawl to swamp all non-trawl gears,
# and non-catch-shares to be insignificant once the catch-share period begins in 2011

# next steps were to combine the Trawl only estimates across the different groups
# with NCS for the years prior to 2011 and the CS for the years after
# plot was written to C:\SS\skates\discards\
head(ncs_2spec)

# rates for SS
SSinputs <- rbind(ncs_3spec[ncs_3spec$ryear < 2011 & ncs_3spec$gear3 == "Trawl",
                            c('ryear','Observed_Ratio','CV.Boot_Ratio')],
                  data.frame(cs_2spec[cs_2spec$ryear %in% 2011:2014 &
                                        cs_2spec$gear3 == "Trawl",
                                      c('ryear','Observed_Ratio'),],
                             CV.Boot_Ratio = 0.01),
                  data.frame(cs_1spec[cs_1spec$ryear >= 2015 &
                                        cs_1spec$gear3 == "Trawl",
                                      c('ryear','Observed_Ratio'),],
                             CV.Boot_Ratio = 0.01))

SSinputs[,2:3] <- round(SSinputs[,2:3], 3)
SSinputs
##     ryear Observed_Ratio CV.Boot_Ratio
## 3    2002          0.628         0.063
## 5    2003          0.326         0.158
## 7    2004          0.399         0.128
## 9    2005          0.218         0.178
## 11   2006          0.204         0.173
## 13   2007          0.236         0.181
## 15   2008          0.060         0.259
## 17   2009          0.092         0.264
## 19   2010          0.060         0.256
## 31   2011          0.099         0.010
## 6    2012          0.104         0.010
## 91   2013          0.124         0.010
## 12   2014          0.119         0.010
## 121  2015          0.129         0.010
## 14   2016          0.156         0.010
## 16   2017          0.140         0.010

### alternative including Longnose for the years up to 2011
data.frame(SSinputs[,1], month=7, fleet=1, SSinputs[,2:3])
##     SSinputs...1. month fleet Observed_Ratio CV.Boot_Ratio
## 3            2002     7     1          0.650         0.057
## 6            2003     7     1          0.381         0.139
## 8            2004     7     1          0.554         0.081
## 10           2005     7     1          0.502         0.095
## 12           2006     7     1          0.427         0.087
## 14           2007     7     1          0.486         0.083
## 16           2008     7     1          0.288         0.094
## 18           2009     7     1          0.259         0.097
## 20           2010     7     1          0.156         0.117
## 31           2011     7     1          0.099         0.010
## 61           2012     7     1          0.104         0.010
## 9            2013     7     1          0.124         0.010
## 121          2014     7     1          0.119         0.010
## 122          2015     7     1          0.129         0.010
## 141          2016     7     1          0.156         0.010
## 161          2017     7     1          0.140         0.010

## look at discard weights
bio <- OBBio[OBBio$COMMON_NAME == "Big Skate",]
plot(bio$LENGTH[bio$SPECIES_NUMBER==1],
     bio$SPECIES_WEIGHT[bio$SPECIES_NUMBER==1], ylim=c(0,10))
abline(h = mean(bio$SPECIES_WEIGHT/bio$SPECIES_NUMBER, na.rm=TRUE))
mean(bio$SPECIES_WEIGHT/bio$SPECIES_NUMBER, na.rm=TRUE)
## [1] 3.077367
abline(v = mean(bio$LENGTH, na.rm=TRUE))
mean(bio$LENGTH, na.rm=TRUE)
## [1] 52.79304


#### Pikitch data from John Wallace
load('C:/SS/skates/discards/Pikitch rates/PikDiscardExtCatchBigSkate.RData')

mean((PikDiscardExtCatchBigSkate$DiscWtExt.lb / PikDiscardExtCatchBigSkate$DiscNumExt)[PikDiscardExtCatchBigSkate$DiscNumExt > 100])
## [1] 1.264087
plot(PikDiscardExtCatchBigSkate$DiscNumExt, PikDiscardExtCatchBigSkate$DiscWtExt.lb / PikDiscardExtCatchBigSkate$DiscNumExt)



# remove deeper water, and non-trawl catch
OBCatch2 <- OBCatch[OBCatch$AVG_DEPTH < 200 & OBCatch$GEAR_TYPE == "TRAWL" ,]
# subset for first record of each unique trip
OBCatch3 <- OBCatch2[!duplicated(OBCatch2$HAUL_ID),]
OBCatch3$BS_MT <- 0
OBCatch3$BS_DIS_MT <- 0
OBCatch3$BS_RET_MT <- 0
for(irow in 1:nrow(OBCatch3)){
  if(irow %% 100 == 0){
    cat(irow, "\n")
  }
  HAUL_ID <- OBCatch3$HAUL_ID[irow]
  records <- which(OBCatch2$HAUL_ID == HAUL_ID & OBCatch2$species == "big skate")
  OBCatch3$BS_MT[irow] <- sum(OBCatch2$MT[records])
  OBCatch3$BS_DIS_MT[irow] <- sum(OBCatch2$DIS_MT[records])
  OBCatch3$BS_RET_MT[irow] <- sum(OBCatch2$RET_MT[records])
}


all_species <- unique(OBCatch$species)
# list of skate species
skate_species <- all_species[grep("skate", tolower(all_species))]

# subset big table to list of skate species
OBCatch_skates <- OBCatch[OBCatch$species %in% skate_species,]
