##Read the provided datasources

features<-read.table("UCI HAR Dataset/features.txt")
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activity_labels)<-c("activity_label","activity_descr")


X_test<-read.table("UCI HAR Dataset/test/X_test.txt")
colnames(X_test)<-features[,2]
y_test<-read.table("UCI HAR Dataset/test/y_test.txt")
colnames(y_test)<-"activity_label"
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
colnames(subject_test)<-"subject"


X_train<-read.table("UCI HAR Dataset/train/X_train.txt")
colnames(X_train)<-features[,2]
y_train<-read.table("UCI HAR Dataset/train/y_train.txt")
colnames(y_train)<-"activity_label"
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
colnames(subject_train)<-"subject"


##Create the test and train tables in order to merge them later
test_data1<-cbind(X_test,y_test,subject_test)
train_data1<-cbind(X_train,y_train,subject_train)

##Merge the data
mergeddata<-rbind(test_data1,train_data1)

##Keep only the mean and standard deviation
##use function grepl to check which features to keep
featurestokeep<-features[grepl("mean()",features$V2,fixed=TRUE)|grepl("std()",features$V2,fixed=TRUE),]

##After finding the name of the columns that have the mean() or std()
##the combined dataset of train and test data is filtered in order to keep only the requested columns
filtereddata<-cbind(mergeddata[,colnames(mergeddata) %in% featurestokeep$V2],
                activity_label=mergeddata[,"activity_label"],
                subject=mergeddata[,"subject"])

##bring the name of the activity in order 
##to use descriptive activity names to name the activities in the data set
filteredwithactivity<-merge(filtereddata,activity_labels,by="activity_label")

##Creation of a table with the average of each variable for each activity and each subject
##Note that the column datasource is excluded since it is not needed in this table
library(dplyr)
tidyfile<-filteredwithactivity %>% group_by(subject,activity_descr) %>% summarise_each(funs(mean))

##export the file to a txt file
write.table(tidyfile, file = "tidydataset.txt", row.name=FALSE, qmethod = "double")


