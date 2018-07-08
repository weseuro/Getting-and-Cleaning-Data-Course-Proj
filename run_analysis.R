
#######################################################################################################
##                                                                                                   ##
##                                     GETTING AND CLEANING DATA                                     ##
##                                                                                                   ##
#######################################################################################################

########################################################################################################
##                                                                                                    ##
## Purpose                                                                                            ##
##                                                                                                    ##  
## 1. Merges the training and the test sets to create one data set.                                   ##
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.         ##
## 3. Uses descriptive activity names to name the activities in the data set                          ##
## 4. Appropriately labels the data set with descriptive variable names.                              ##
## 5. From the data set in step 4, creates a second, independent tidy data set with the average       ##
## of each variable for each activity and each subject.                                               ##
##                                                                                                    ##
########################################################################################################


library(reshape2)
library(data.table)

## Get Data

datazip <- "GaCD_data.zip"

if (!file.exists(datazip)){
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, datazip, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(datazip) 
}

# Read activity labels and features
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("./UCI HAR Dataset/features.txt")[,2]
head(features)

#######################################################################################################
##                                            TRAIN DATA                                             ##
#######################################################################################################
# Read data
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Assign column names
colnames(x_train) <- features

# Get mean and std for the measurements
x_train <- x_train[,grepl("mean|std", features)]

head(x_train,1)

# Clean activity data
y_train[,2] <- activity_labels[y_train[,1]]
# Assign column names
colnames(y_train) <- c("activity_ID","activity_label")
colnames(subject_train) <- "subject"

head(y_train)
head(subject_train)

# Bind data
train <- cbind(as.data.table(subject_train),y_train,x_train)
head(train,2)

#######################################################################################################
##                                            TEST DATA                                              ##
#######################################################################################################

# Read data
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

colnames(x_test) <- features

# Get mean and std for the measurements
x_test <- x_test[,grepl("mean|std", features)]

head(x_test,1)

# Clean activity data
y_test[,2] <- activity_labels[y_test[,1]]
# Assign column names
colnames(y_test) <- c("activity_ID","activity_label")
colnames(subject_test) <- "subject"

head(y_test)
head(subject_test)

# Bind data
test <- cbind(as.data.table(subject_test),y_test,x_test)
head(test,2)

#######################################################################################################
##                                                MERGE                                              ##
#######################################################################################################
comp = rbind(train,test)
col <- c("subject","activity_ID","activity_label")
col2 <- setdiff(colnames(comp),col)
comp2 <- melt(comp,id=col,measure.vars=col2)

#######################################################################################################
##                                                TIDY                                               ##
#######################################################################################################
# Create tidy data
tidy <- dcast(comp2,subject+activity_label~variable,mean)
write.table(tidy, file = "./tidy.txt",row.name = FALSE)
