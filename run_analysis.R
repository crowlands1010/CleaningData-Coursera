## Getting & Cleaning Data Course Project
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the 
##    average of each variable for each activity and each subject.

library(dplyr)
library(reshape2)

## Download File
if (!file.exists("data")) {
  dir.create("data")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" ##testdata
download.file(fileUrl,destfile="./data/Dataset.zip")

unzip(zipfile="./data/Dataset.zip",exdir="./data")

## Read Datasets
## Datasets for Test
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")

## Datasets for Train
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")

## 1. Merges the training and the test sets to create one data set.
testBind <- cbind(subject_test,x_test,y_test)
trainBind <- cbind(subject_train,x_train,y_train) 
mergedData <- rbind(testBind,trainBind)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("./data/UCI HAR Dataset/features.txt")
meanStDev <- features[grep('-(mean|std)\\(\\)', features[, 2 ]), 2]
mergedData <- mergedData[, c(1, 2, meanStDev)]

## 3. Uses descriptive activity names to name the activities in the data set
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
mergedData[, 2] <- activities[mergedData[,2], 2]

# 4. Appropriately labels the data set with descriptive variable names. 
colnames(mergedData) <- c('subject','activity',gsub('\\-|\\(|\\)', '', as.character(requiredFeatures)))
mergedData[, 2] <- as.character(mergedData[, 2])


## 5. From the data set in step 4, creates a second, independent tidy data set with the 
##    average of each variable for each activity and each subject.
datasetMelt <- melt(mergedData,id=c('subject','activity'))
datasetMean <- dcast(datasetMelt, subject+activity~variable,mean)

write.table(datasetMean, file=file.path("tidy.csv"), row.names = TRUE, quote = FALSE)
write.table(datasetMean, file=file.path("tidy.txt"), row.names = TRUE, quote = FALSE)