# Getting-and-Cleaning-Data-Course-Proj
Project for JHU Getting and Cleaning Data Course - FINAL

## The repository contains the following files
- **README.md** an overview of what the purpose of the repository; and how the script works
- **run_analysis.R** a script performing the creation of the tidy data from the Samsung raw files
- **CODEBOOK.md** a description of the variables used in the study
- **tidy.txt** the processed data set

## How *run_analysis.R* works

### Dependencies and Transformation
1. The script is dependent on 2 R packages: *data.table* and *reshape2*
2. Loads a zipfile containing Samsung data. 
3. Calls and loads the train data set and retain the mean and standard deviation metrics. This includes proper labeling and assigning descriptive variable names.
4. Calls and loads the test data set and retain the mean and standard deviation metrics. This includes proper labeling and assigning descriptive variable names.
5. Merging these two data sets
6. Creating a tidy data out of the output in *step 4*  and getting the average of each variable for each acitivity and each subject

