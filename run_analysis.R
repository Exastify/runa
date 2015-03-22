library(plyr)
library(Rcpp)
library(reshape2)

message("loading train");
xtrain <- read.table("uci/train/X_train.txt")
subjecttrain <- read.table("uci/train/subject_train.txt")
ytrain <- read.table("uci/train/y_train.txt")

message("loading test");
xtest <- read.table("uci/test/X_test.txt")
subjecttest <- read.table("uci/test/subject_test.txt")
ytest <- read.table("uci/test/y_test.txt")

message("loading misc");
activitylabels <- read.table("uci/activity_labels.txt")
features <- read.table("uci/features.txt")

#Add the labels of the data
names(xtrain) <- features[,2]
names(xtest) <- features[,2]

#Merge train and test together
subject <- rbind(subjecttrain,subjecttest)
x <- rbind(xtrain,xtest)
y <- rbind(ytrain,ytest)

#Only get mean and standard deviation
ms <- grepl("std\\(\\)|mean\\(\\)", features[,2])

#Isolate mean and std
xms <- x[,ms]

#Combine them together
c <- cbind(subject,y,xms)

#Add the first two labels
names(c)[1] <- "SubjectID"
names(c)[2] <- "Activity"

#Average data for step 5
agg <- aggregate(. ~ SubjectID + Activity, data=c, FUN = mean)
agg$Activity <- factor(agg$Activity, labels=activitylabels[,2])

message("writing final")
write.table(agg, file="./tidydataset.txt", sep="\t", row.names=FALSE)