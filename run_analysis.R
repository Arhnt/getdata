library(dplyr)

# This function: 
# * reads test and train parts of Samsung data
# * merges them in single data set
# * selects only measurements with "mean()" and "std()"
# * calculates average value for each selected feature by activity and subject
# Parameters:
# (optional) data - either directory or zip filename with data
#                   default "UCI HAR Dataset"
# Output:
# tbl_df with 68 columns and 180 rows (6 activities * 30 subjects)
#
# Usage: avg <- run_analysis()
#
run_analysis <- function(data = "UCI HAR Dataset") {
    temporary_directory <- NULL;
    data_directory <- NULL;
    if (dir.exists(data)) {
        message("Found directory with extracted data");
        data_directory <- data;
    } else if (file.exists(data)) {
        temporary_directory <- file.path(tempdir(), "UCI HAR Dataset");
        message("Extracting data to: ", temporary_directory);
        unzip(data, exdir = tempdir());
        data_directory <- temporary_directory;
    } else if (file.exists(paste(data, ".zip", sep = ""))) {
        temporary_directory <- file.path(tempdir(), "UCI HAR Dataset");
        message("Extracting data to: ", temporary_directory);
        unzip(paste(data, ".zip", sep = ""), exdir = tempdir());
        data_directory <- temporary_directory;
    } else {
        stop("Cannot find data ", data)
    }
    
    message("Working with data in directory: ", data_directory);
    full_data <- read_data(data_directory);
    
    if (!is.null(temporary_directory)) {
        message("Removing data from temporary directory: ", temporary_directory);
        unlink(temporary_directory, recursive = TRUE);
    }
    
    full_data %>%
    group_by(activity, subject) %>%
    summarize_each(funs(mean))
}


read_data <- function(data_directory) {
    final_data <- NULL;
    
    features <- read.table(file.path(data_directory, "features.txt"), stringsAsFactors = FALSE);
    feature_indexes <- grep("-mean\\(\\)|-std\\(\\)", features[,2]);
    
    for (step in c("test", "train")) {
        message("Loading data from: ", step);
        
        x_file <- file.path(data_directory, step, paste("X_", step, ".txt", sep = ""));
        x_data <- read.table(x_file, stringsAsFactors = FALSE) %>%
                  select(feature_indexes);
        
        y_file <- file.path(data_directory, step, paste("y_", step, ".txt", sep = ""));
        y_data <- read.table(y_file, stringsAsFactors = FALSE);
        colnames(y_data) <- c("activity");
        
        subject_file <- file.path(data_directory, step, paste("subject_", step, ".txt", sep = ""));
        subject <- read.table(subject_file, stringsAsFactors = FALSE);
        colnames(subject) <- c("subject");
        
        step_data <- bind_cols(subject, y_data, x_data);
        final_data <- bind_rows(final_data, step_data);
    }
    
    # Add descriptive names
    features[, 2] <- gsub("(", "", features[, 2], fixed = TRUE);
    features[, 2] <- gsub(")", "", features[, 2], fixed = TRUE);
    features[, 2] <- gsub("-", "_", features[, 2], fixed = TRUE);
    colnames(final_data) <- c("subject", "activity", features[feature_indexes, 2]);
    
    # Mutate activities from integer to factors
    activities <- read.table(file.path(data_directory, "activity_labels.txt"), stringsAsFactors = FALSE);
    final_data$activity <- factor(final_data$activity, levels = 1:6, labels = activities[, 2]);

    final_data
}
