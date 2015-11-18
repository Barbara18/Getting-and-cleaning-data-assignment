analysis <- function(){
  
  subject_test = read.table("test.txt")
  X_test = read.table("X_test.txt")
  Y_test = read.table("Y_test.txt")
  
  subject_train = read.table("train.txt")
  X_train = read.table("X_train.txt")
  Y_train = read.table("Y_train.txt")
  
  
  features <- read.table("features.txt", col.names=c("featureId", "featureLabel"))
  activities <- read.table("labels.txt", col.names=c("activityId", "activityLabel"))
  activities$activityLabel <- gsub("_", "", as.character(activities$activityLabel))
  includedFeatures <- grep("-mean\\(\\)|-std\\(\\)", features$featureLabel)
  
  subject <- rbind(subject_test, subject_train)
  names(subject) <- "subjectId"
  X <- rbind(X_test, X_train)
  X <- X[, includedFeatures]
  names(X) <- gsub("\\(|\\)", "", features$featureLabel[includedFeatures])
  Y <- rbind(Y_test, Y_train)
  names(Y) = "activityId"
  activity <- merge(Y, activities, by="activityId")$activityLabel
  
  
  data <- cbind(subject, X, activity)
  write.table(data, "merged data.txt")
  
  
  library(data.table)
  dataDT <- data.table(data)
  calculatedData<- dataDT[, lapply(.SD, mean), by=c("subjectId", "activity")]
  write.table(calculatedData, "calculated data.txt")
}