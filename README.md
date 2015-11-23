The script run_analysis.R should be run under the directory under which the unzipped data directory "UCI HAR Dataset" is its child directory. The script should be run without any input argument to it. The script will read inputs from data files and genereate the result tidy data. 

At the first, the script reads the data into data frame: subject_train, x_train, y_train, subject_test, x_test, y_test. And then the script modifies the script to add column names. The script also use the activity_labels.txt to convert the activity number to names. 

The script uses cbine to combine all the data for test set together, and do the same for the train data set. Then the script use rbine to combine all the data for test set and train set together. 

In the end the script uses meld and dcast to calculate the average of each variable for each activity and each subject. 
