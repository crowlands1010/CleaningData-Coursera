## Getting & Cleaning Data Course Project
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the 
##    average of each variable for each activity and each subject.

library(dplyr)
library(data.table)

## Download File
if (!file.exists("data")) {
  dir.create("data")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" ##testdata
download.file(fileUrl,destfile="./data/Dataset.zip")

unzip(zipfile="./data/Dataset.zip",exdir="./data")

## Read Datasets
## Datasets for Test
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt",sep="")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt",sep="")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt",sep="")

## Datasets for Train
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt",sep="")
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt",sep="")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt",sep="")

## 1. Merges the training and the test sets to create one data set.
testBind <- cbind(subject_test,x_test,y_test)
trainBind <- cbind(subject_train,x_train,y_train) 
mergedData <- rbind(testBind,trainBind)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("./data/UCI HAR Dataset/features.txt")
features <- features %>% select(2) %>% t
meanStDev <- features[grep('-(mean|std)\\(\\)', features[, 2 ]), 2]

## 3. Uses descriptive activity names to name the activities in the data set
extract <- select(complete, matches("Subject|Activity|mean\\(\\)|std\\(\\)"))


# 4. Appropriately labels the data set with descriptive variable names. 
extract$Activity <- gsub("1", "walking", extract$Activity)
extract$Activity <- gsub("2", "walking upstairs", extract$Activity)
extract$Activity <- gsub("3", "walking downstairs", extract$Activity)
extract$Activity <- gsub("4", "sitting", extract$Activity)
extract$Activity <- gsub("5", "standing", extract$Activity)
extract$Activity <- gsub("6", "laying", extract$Activity)

names(extract) <- gsub("^f", "FFT", names(extract))
names(extract) <- gsub("^t", "", names(extract))
names(extract) <- gsub("-mean\\(\\)", "Mean", names(extract))
names(extract) <- gsub("-std\\(\\)", "StdDeviation", names(extract))
names(extract) <- gsub("BodyBody", "Body", names(extract))
names(extract) <- gsub("BodyGyro", "AngularVelocity", names(extract))
names(extract) <- gsub("AngularVelocityJerk", "AngularJerk", names(extract))
names(extract) <- gsub("BodyAccJerk", "LinearJerk", names(extract))
names(extract) <- gsub("BodyAcc", "BodyAccel", names(extract))
names(extract) <- gsub("GravityAcc", "GravityAccel", names(extract))
names(extract) <- gsub("-X", "XAxis", names(extract))
names(extract) <- gsub("-Y", "YAxis", names(extract))
names(extract) <- gsub("-Z", "ZAxis", names(extract))

## 5. From the data set in step 4, creates a second, independent tidy data set with the 
##    average of each variable for each activity and each subject.
tidyDataSet <- group_by(extract, Subject, Activity) %>% summarize_each(funs(mean))
write.table(tidyDataSet,file="tidy.txt",row.names=TRUE)
