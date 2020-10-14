## ---------------------------
## Data aggregation of all miniDOT data
##
## Author: Kelly A. Loria
## Date Created: 2020-10-12
## Email: kelly.loria@nevada.unr.edu

## ---------------------------
#Load packages
library(plyr)
library(dplyr)
library(ggplot2)
library(cowplot)
library(streamMetabolizer)
library(lubridate)
library(reshape2)
library(LakeMetabolizer)

## ---------------------------
# File path setup:
if (dir.exists('/Users/kellyloria/Documents/UNR_2020/Fall2020Projects/miniDOT_2020PrelimDat')){
  inputDir<- '/Users/kellyloria/Documents/UNR_2020/Fall2020Projects/miniDOT_2020PrelimDat'
  outputDir<- '/Users/kellyloria/Documents/UNR_2020/Fall2020Projects/miniDOT_2020PrelimDat/Clean_PrelimDat' 
}

## ---------------------------
# Calibration offsets for all sensors
# load in raw data
cal_547404 <- read.delim(paste0(inputDir, "/SeptemberMiniDOTCalibration/547404/Cat_copy.TXT"), header=T, sep = ',')
summary(cal_547404)
cal_547404$Seiral <- "547404"

cal_555348 <- read.delim(paste0(inputDir, "/SeptemberMiniDOTCalibration/555348/Cat_copy.TXT"), header=T, sep = ',')
summary(cal_555348)
cal_555348$Seiral <- "555348"

cal_617000 <- read.delim(paste0(inputDir, "/SeptemberMiniDOTCalibration/617000/Cat_copy.TXT"), header=T, sep = ',')
summary(cal_617000)
cal_617000$Seiral <- "617000"

cal_666671 <- read.delim(paste0(inputDir, "/SeptemberMiniDOTCalibration/666671/Cat_copy.TXT"), header=T, sep = ',')
summary(cal_666671)
cal_666671$Seiral <- "666671"

cal_714094 <- read.delim(paste0(inputDir, "/SeptemberMiniDOTCalibration/714094/Cat_copy.TXT"), header=T, sep = ',')
summary(cal_714094)
cal_714094$Seiral <- "714094"

# Aggregate all calibration data
Sept_Cal <- rbind(cal_547404, cal_555348, cal_617000, cal_666671, cal_714094)
summary(Sept_Cal)
head(Sept_Cal)

# attempting to convert dt1$timestamp dateTime string to R date structure (date or POSIXct)                                
tmpDateFormat<-"%Y-%m-%d %H:%M:%S" 
tmp1timestamp<-as.POSIXct(Sept_Cal$Pacific.Standard.Time,format=tmpDateFormat)
# Keep the new dates only if they all converted correctly
if(length(tmp1timestamp) == length(tmp1timestamp[!is.na(tmp1timestamp)])){Sept_Cal$timestamp <- tmp1timestamp } else {print("Date conversion failed for dt1$timestamp. Please inspect the data and do the date conversion yourself.")}    

qplot(timestamp, Dissolved.Oxygen.Saturation, data = Sept_Cal, geom="line", ylab = "Sat", color = factor(Seiral)) +
  theme(axis.text.x = element_text(angle = 25, vjust = 1.0, hjust = 1.0))

# restrict time window to 
Sept_CalQ <- subset(Sept_Cal,timestamp >= as.POSIXct('2020-09-14 13:30:00') & 
                     timestamp <= as.POSIXct('2020-09-16 10:00:00'))
range(Sept_CalQ$timestamp)

qplot(timestamp, Dissolved.Oxygen.Saturation, data = Sept_CalQ, geom="line", ylab = "Sat", color = factor(Seiral)) +
  theme(axis.text.x = element_text(angle = 25, vjust = 1.0, hjust = 1.0))

# write.csv(Sept_CalQ, paste0(outputDir,"Sept2020_CalDatQ.csv")) # complied data file of all RBR sensors along buoy line


## ---------------------------
# Aggregate data by site 

# Blackwood:
Blackwood_prelim <- read.delim(paste0(inputDir, "/Blackwood_7450-617000/Cat_copy.TXT"), header=T, sep = ',')
summary(Blackwood_prelim)
Blackwood_prelim$Site <- "Blackwood"
Blackwood_prelim$Seiral <- "617000"

# attempting to convert dt1$timestamp dateTime string to R date structure (date or POSIXct)                                
tmpDateFormat<-"%Y-%m-%d %H:%M:%S" 
tmp1timestamp<-as.POSIXct(Blackwood_prelim$Pacific.Standard.Time,format=tmpDateFormat)
# Keep the new dates only if they all converted correctly
if(length(tmp1timestamp) == length(tmp1timestamp[!is.na(tmp1timestamp)])){Blackwood_prelim$timestamp <- tmp1timestamp } else {print("Date conversion failed for dt1$timestamp. Please inspect the data and do the date conversion yourself.")}    

Blackwood_prelimQ <- subset(Blackwood_prelim,timestamp >= as.POSIXct('2020-09-27 15:00:00') & 
                      timestamp <= as.POSIXct('2020-10-11 10:30:00'))
range(Sept_CalQ$timestamp)

qplot(timestamp, Dissolved.Oxygen.Saturation, data = Blackwood_prelimQ, geom="line", ylab = "Sat", color = factor(Site)) +
  theme(axis.text.x = element_text(angle = 25, vjust = 1.0, hjust = 1.0))

# write.csv(Blackwood_prelimQ, (paste0(outputDir,"/Blackwood_2020prelimQ.csv"))) # complied data file of all RBR sensors along buoy line

# General:
General_prelim <- read.delim(paste0(inputDir, "/General_7450-547404/Cat_copy.TXT"), header=T, sep = ',')
summary(General_prelim)
General_prelim$Site <- "General"
General_prelim$Seiral <- "547404"

# attempting to convert dt1$timestamp dateTime string to R date structure (date or POSIXct)                                
tmpDateFormat<-"%Y-%m-%d %H:%M:%S" 
tmp1timestamp<-as.POSIXct(General_prelim$Pacific.Standard.Time,format=tmpDateFormat)
# Keep the new dates only if they all converted correctly
if(length(tmp1timestamp) == length(tmp1timestamp[!is.na(tmp1timestamp)])){General_prelim$timestamp <- tmp1timestamp } else {print("Date conversion failed for dt1$timestamp. Please inspect the data and do the date conversion yourself.")}    

General_prelimQ <- subset(General_prelim,timestamp >= as.POSIXct('2020-09-30 16:00:00') & 
                              timestamp <= as.POSIXct('2020-10-10 10:00:00'))
range(General_prelimQ$timestamp)

qplot(timestamp, Dissolved.Oxygen.Saturation, data = General_prelimQ, geom="line", ylab = "Sat", color = factor(Site)) +
  theme(axis.text.x = element_text(angle = 25, vjust = 1.0, hjust = 1.0))

# write.csv(General_prelimQ, (paste0(outputDir,"/General_prelimQ.csv"))) # complied data file of all RBR sensors along buoy line

# Ward:
Ward_prelim <- read.delim(paste0(inputDir, "/Ward_7450-555348/Cat_copy.TXT"), header=T, sep = ',')
summary(Ward_prelim)
Ward_prelim$Site <- "Ward"
Ward_prelim$Seiral <- "555348"

# attempting to convert dt1$timestamp dateTime string to R date structure (date or POSIXct)                                
tmpDateFormat<-"%Y-%m-%d %H:%M:%S" 
tmp1timestamp<-as.POSIXct(Ward_prelim$Pacific.Standard.Time,format=tmpDateFormat)
# Keep the new dates only if they all converted correctly
if(length(tmp1timestamp) == length(tmp1timestamp[!is.na(tmp1timestamp)])){Ward_prelim$timestamp <- tmp1timestamp } else {print("Date conversion failed for dt1$timestamp. Please inspect the data and do the date conversion yourself.")}  

Ward_prelimQ <- subset(Ward_prelim,timestamp >= as.POSIXct('2020-09-26 19:00:00') & 
                            timestamp < as.POSIXct('2020-10-10 11:00:00'))
range(Ward_prelimQ$timestamp)

Ward_prelim0 <- read.delim(paste0(inputDir, "/Ward_7450-555348/Ward_PilotData/7450-714094/Cat_copy.TXT"), header=T, sep = ',')
summary(Ward_prelim0)
Ward_prelim0$Site <- "Ward"
Ward_prelim0$Seiral <- "714094"

# attempting to convert dt1$timestamp dateTime string to R date structure (date or POSIXct)                                
tmpDateFormat<-"%Y-%m-%d %H:%M:%S" 
tmp1timestamp<-as.POSIXct(Ward_prelim0$Pacific.Standard.Time,format=tmpDateFormat)
# Keep the new dates only if they all converted correctly
if(length(tmp1timestamp) == length(tmp1timestamp[!is.na(tmp1timestamp)])){Ward_prelim0$timestamp <- tmp1timestamp } else {print("Date conversion failed for dt1$timestamp. Please inspect the data and do the date conversion yourself.")}  

Ward_prelim0Q <- subset(Ward_prelim0,timestamp >= as.POSIXct('2020-09-18 10:30:00') & 
                         timestamp < as.POSIXct('2020-09-26 18:20:00'))
range(Ward_prelim0Q$timestamp)

qplot(timestamp, Dissolved.Oxygen.Saturation, data = Ward_prelim0Q, geom="line", ylab = "Sat", color = factor(Site)) +
  theme(axis.text.x = element_text(angle = 25, vjust = 1.0, hjust = 1.0))

Ward_prelimQ2 <- rbind(Ward_prelim0Q, Ward_prelimQ)
summary(Ward_prelimQ2)

# write.csv(Ward_prelimQ2, (paste0(outputDir,"/Ward_prelimQ.csv")))

## ---------------------------
# Check out patterns by site
prelimDO_2020 <- rbind(Ward_prelimQ2, General_prelimQ, Blackwood_prelimQ)

p <- ggplot(prelimDO_2020, aes(x=timestamp, y=(Dissolved.Oxygen.Saturation), colour =as.factor(Site), shape=(Seiral))) +
  geom_line()  + ylab("DO Sat") +
  theme_classic() + facet_wrap(~Site)
