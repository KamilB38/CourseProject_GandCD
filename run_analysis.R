## Script is used for cleaning dataset
## Merge training and test datasets 
## Labeling columns with meaningfull names and some cleaning
## Numeric activity code is labeled with meaningfull names
## cleaned data is written to csv file:merged_data.csv
## Calculates averagevalue per activity per subject
## aggregated data is written to csv file:agg_mean_data.csv

# create dir else print message
if (!file.exists("./courseproject")) {dir.create("./courseproject")} else stop("directory with name 'courseproject' already exists: please rename your existing directory or find/replace 'courseproject' in current script'")

# file url
zipfile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# download file
download.file(zipfile,destfile="./courseproject/Dataset.zip", mode="wb")

# unzip de new file
unzip(zipfile="./courseproject/Dataset.zip",exdir="./courseproject")

#unzipped files are in "UCI HAR Dataset"
path <- file.path("./courseproject" , "UCI HAR Dataset")

test.y                 <- read.table(file.path(path, "test" , "Y_test.txt" ),      header = FALSE) #activity data test
train.y                <- read.table(file.path(path, "train", "Y_train.txt"),      header = FALSE) #activity data train
test.subject           <- read.table(file.path(path, "test" , "subject_test.txt"), header = FALSE) #subject data test
train.subject          <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE) #subject data train
test.x                 <- read.table(file.path(path, "test" , "x_test.txt" ),      header = FALSE) #features data test
train.x                <- read.table(file.path(path, "train", "x_train.txt"),      header = FALSE) #features data train
features.labels        <- read.table(paste(path, 'features.txt', sep = '/'),       header = FALSE) #features column labels
activity.labels        <- read.table(paste(path, 'activity_labels.txt', sep = '/'),header = FALSE) #activity column labels
names(activity.labels) <- c('id', 'name')
names(features.labels) <- c('id', 'name')
names(train.x)         <- features.labels$name
names(train.y)         <- c('activity')
names(train.subject)   <- c('subject')
names(test.x)          <- features.labels$name
names(test.y)          <- c('activity')
names(test.subject)    <- c('subject')
names(activity.labels) <- c('id', 'name')
names(features.labels) <- c('id', 'name')

# Merge (vertically) the training and test sets 
features <- rbind(train.x, test.x)
activity <- rbind(train.y, test.y)
subject  <- rbind(train.subject, test.subject)

# subset the relevant columns with mean and std in the names
features <- features[, grep('mean|std', names(features))]
names(features) <- gsub("\\(","",names(features))
names(features) <- gsub("\\)","",names(features))

# Lookup to reference table "acts" to convert numbers to name labels
activity$activity <- features.labels[activity$activity,]$name

# Merge (horizontally) 3 data.frame's 
merged.data <- cbind(subject, activity, features)

# write to file 1 (non-aggragated clean data)
write.csv(merged.data, file="./courseproject/merged_data.csv")

# Compute the averages grouped by subject and activity
agg.mean.data <- aggregate(    merged.data[,3:length(names(merged.data))],by=list(merged.data$subject,merged.data$activity),mean)
names(agg.mean.data)[1:2] <- c('subject', 'activity')

#  write to file 1 (aggregated data)
write.csv(agg.mean.data, file="./courseproject/agg_mean_data.csv")
write.table(agg.mean.data, file="./courseproject/agg_mean_data_for_upload.txt",row.name=FALSE)
























