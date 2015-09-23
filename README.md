## Getting and Cleaning Data by Coursera
### Description
#### Script
This project contaibs R script called **run_analysis.R** that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#### Data
The data linked to the project represent data collected from the accelerometers from the Samsung Galaxy S smartphone.

A full description is available at the site where the data was obtained: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

#### Data Local Files
* **run_analysis()** tries to find and use extracted data
* if extracted data is not availabe:
    - function extracts data archive to the temporary directory
    - temporary directory is removed after execution

#### Environment
This project was created and tested on:

* Mac OS X [10.10.4]
* R [3.2.1]
* RStudio [0.99.467]
* dplyr [0.4.3]

### PreRequisites
* Project data **UCI HAR Dataset.zip** in the working directory
    - Data can be downloaded with `download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "UCI HAR Dataset.zip", method = "curl")`
* dplyr package installed
    + Package can be installed with `install.packages("dplyr")`


### Execution Steps
1. Set working directory to directory where *run_analysis.R* and *UCI HAR Dataset.zip* are located
2. Source *run_analysis.R* with `source("run_analysis.R")`
3. Execute `run_analysis()`
    + **run_analysis()** accepts parameter *data* which may be set to archive name or directory name with extracted data. Default data = "UCI HAR Dataset"
4. To save result data set to a file execute `data <- run_analysis(); write.table(data, "samsung-tidy-data.txt", row.names = FALSE)`
