#Initial configuration set-up 
getwd()
setwd("C:/Users/Arvin/Desktop/Coursera_assignments")
library(dplyr)
library(RCurl)
library(tidyverse)

#Starting the download of the dataset file
C3datafile <- "Coursera_Wk3_dataset.zip"
if (!file.exists(C3datafile)) {
     datafileurl <-
 "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
     download.file(datafileurl, C3datafile, method = "curl", mode="wb")
}    
#Checking the files and listing them
if (!file.exists("UCI HAR Dataset")) {
     unzip(C3datafile)}
list.files ("UCI HAR Dataset", recursive = TRUE)

#Reading into the dataframes and assigning the variables
data_features <- read.table("UCI HAR Dataset/features.txt", 
     col.names = c("n","functions"))
data_activities <- read.table("UCI HAR Dataset/activity_labels.txt", 
col.names = c("code", "activity"))

x_train <- read.table("UCI HAR Dataset/train/X_train.txt", 
col.names = data_features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", 
col.names = "Act_Code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", 
col.names = "Sub_Code")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt", 
col.names = data_features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", 
col.names = "Act_Code")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", 
col.names = "Sub_Code")


#For objective1:Merge the training and the test datasets into one data set.
merged_train_data= cbind(y_train, subject_train, x_train)
merged_test_data= cbind(y_test, subject_test, x_test)
## Merging both the above datasets
BothSets_merged<- rbind(merged_train_data, merged_test_data)

#For Objective2:Extract only the measurements 
#on the mean and standard deviation for each measurement.
Dataset_mean_std <- BothSets_merged %>% select("Sub_Code", "Act_Code", contains("mean"), contains("std"))

#For Objective3&4:Use descriptive activity names 
#to name the activities in the data set.
Dataset_mean_std$Act_Code<-data_activities[Dataset_mean_std$Act_Code, 2]

#For objective4: Appropriately labels the data set with 
#descriptive variable names.
names(Dataset_mean_std)[1] = "Subject_ID"
names(Dataset_mean_std)[2] = "Activity"
names(Dataset_mean_std)<-gsub("Acc", "Accelerometer", names(Dataset_mean_std))
names(Dataset_mean_std)<-gsub("Gyro", "Gyrometer", names(Dataset_mean_std))
names(Dataset_mean_std)<-gsub("Mag", "Magnitude", names(Dataset_mean_std))
names(Dataset_mean_std)<-gsub("^f", "Frequency", names(Dataset_mean_std))
names(Dataset_mean_std)<-gsub("-freq()", "Frequency", names(Dataset_mean_std))
names(Dataset_mean_std)<-gsub("tBody", "TimeBody", names(Dataset_mean_std))


#5.	From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.

Second_dataset<- aggregate(.~Subject_ID + Activity, Dataset_mean_std, mean)
Third_dataset<- Second_dataset[order(Second_dataset$Subject_ID, 
Second_dataset$Activity),]
write.table(Third_dataset, "Data-revised.txt", row.names=FALSE)

#End of the script "run_analysis.R" 