#######unzip the data for the project: 
unzip ("getdata-projectfiles-UCI HAR Dataset.zip",exdir = "./")

########Reading all files in tables
y_train = read.table("./UCI HAR Dataset/train/y_train.txt")
x_train = read.table("./UCI HAR Dataset/train/X_train.txt")
subject_train = read.table("./UCI HAR Dataset/train/subject_train.txt")

y_test = read.table("./UCI HAR Dataset/test/y_test.txt")
x_test = read.table("./UCI HAR Dataset/test/X_test.txt")
subject_test = read.table("./UCI HAR Dataset/test/subject_test.txt")

activity_labels = read.table("./UCI HAR Dataset/activity_labels.txt")
features = read.table("./UCI HAR Dataset/features.txt")

######label the column names with the features
colnames(x_test) <- features[[2]]
colnames(x_train) <- features[[2]]

#########extract columns with standard deviation or mean calculation
x_test_Extracts <- x_test[, grepl("std\\(\\)|mean\\(\\)", ignore.case = TRUE, names(x_test)), drop = FALSE]
x_train_Extracts <- x_train[, grepl("std\\(\\)|mean\\(\\)", ignore.case = TRUE, names(x_train)), drop = FALSE]


########add a column with the activity named
return_activity <- function(x) activity_labels[activity_labels[1]==x[1],2]
x_test_Extracts[, "activity"]  <- apply(y_test, 1, return_activity)
x_train_Extracts[, "activity"]  <- apply(y_train, 1, return_activity)

########add a column group defining if the group is train or test
#x_test_Extracts[, "group"]  <- "TEST"
#x_train_Extracts[, "group"]  <- "TRAIN"

########add a column group defining if the subject_number
x_test_Extracts[, "subject_number"]  <- subject_test
x_train_Extracts[, "subject_number"]  <- subject_train


################Merge both table
total <- rbind(x_test_Extracts, x_train_Extracts)

######extract means by subject and activit
means_table <- aggregate(total[,1:66], by = list (subject=total$subject_number, activity=total$activity), mean, na.rm=TRUE)

######write to file
write.table(means_table, file="tidy_data.txt", row.name=FALSE)



  