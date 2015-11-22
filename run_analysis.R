library(reshape2)
library(plyr)

activity_labels<-read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)
features<-read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)

subject_train<-read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)
x_train<-read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
y_train<-read.csv("UCI HAR Dataset/train/y_train.txt", sep="", header=FALSE)

subject_test<-read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)
x_test<-read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
y_test<-read.csv("UCI HAR Dataset/test/y_test.txt", sep="", header=FALSE)


subject_test <- setNames(subject_test, c("subject"))
subject_train <- setNames(subject_train, c("subject"))

#colnames(x_test) <- paste("feature", colnames(x_test), sep = "_")
#colnames(x_train) <- paste("feature", colnames(x_train), sep = "_")
x_test<-setNames(x_test, features$V2)
x_train<-setNames(x_train, features$V2)
selected_measurements <- grep("mean|std", names(x_test), ignore.case=TRUE, value=TRUE)
selected_x_test<-x_test[, selected_measurements]
selected_x_train<-x_train[, selected_measurements]

y_test<-setNames(y_test, c("activity"))
y_train<-setNames(y_train, c("activity"))

activity_labels<-setNames(activity_labels, c("activity_num", "activity_label"))
activity_labels$activity_num<-lapply(activity_labels$activity_num, as.numeric)
activity_labels$activity_label<-lapply(activity_labels$activity_label, as.character)

y_test$activity<-mapvalues(y_test$activity,   from=activity_labels$activity_num, to=activity_labels$activity_label)
y_train$activity<-mapvalues(y_train$activity, from=activity_labels$activity_num, to=activity_labels$activity_label)


test_data<-cbind(subject_test,y_test)
test_data<-cbind(test_data, selected_x_test)

train_data<-cbind(subject_train,y_train)
train_data<-cbind(train_data, selected_x_train)

combined_data <- rbind(test_data, train_data)

data_melted <- melt(combined_data, id=c("subject", "activity"))
write.table(data_melted, file="tidy.txt", row.names=FALSE, quote=FALSE)
