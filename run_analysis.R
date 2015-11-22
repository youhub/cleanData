library(reshape2)
library(plyr)

# read input files
activity_labels<-read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)
features<-read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)

subject_train<-read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)
x_train<-read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
y_train<-read.csv("UCI HAR Dataset/train/y_train.txt", sep="", header=FALSE)

subject_test<-read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)
x_test<-read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
y_test<-read.csv("UCI HAR Dataset/test/y_test.txt", sep="", header=FALSE)

# set the column name as subject
subject_test <- setNames(subject_test, c("subject"))
subject_train <- setNames(subject_train, c("subject"))

# use meaningful column name using the feature file
x_test<-setNames(x_test, features$V2)
x_train<-setNames(x_train, features$V2)

# only filter out mean and standard deviation measurements
selected_measurements <- grep("mean|std", names(x_test), ignore.case=TRUE, value=TRUE)
selected_x_test<-x_test[, selected_measurements]
selected_x_train<-x_train[, selected_measurements]

# set the column as activity
y_test<-setNames(y_test, c("activity"))
y_train<-setNames(y_train, c("activity"))

# convert activity number to labels
activity_labels<-setNames(activity_labels, c("activity_num", "activity_label"))
activity_labels$activity_num<-lapply(activity_labels$activity_num, as.numeric)
activity_labels$activity_label<-lapply(activity_labels$activity_label, as.character)

y_test$activity<-mapvalues(y_test$activity,   from=activity_labels$activity_num, to=activity_labels$activity_label)
y_train$activity<-mapvalues(y_train$activity, from=activity_labels$activity_num, to=activity_labels$activity_label)

# combine all test data
test_data<-cbind(subject_test,y_test)
test_data<-cbind(test_data, selected_x_test)

#combine all train data
train_data<-cbind(subject_train,y_train)
train_data<-cbind(train_data, selected_x_train)

#combine test data with train data
combined_data <- rbind(test_data, train_data)

data_melted <- melt(combined_data, id=c("subject", "activity"))

tidy_data <- dcast(data_melted, activity + subject ~ variable, mean)
write.table(tidy_data, file="tidy.txt", row.names=FALSE, quote=FALSE)
