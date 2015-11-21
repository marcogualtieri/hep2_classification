# hep2_classification

Segmentate and classify HEp2 cells images.

Steps to run:

##### 1. Prepare the configuration file
Compile configuration.m file with proper values for files path and classes.

##### 2. Run createSvmDataset.m
This script is responsible of loading images, preprocessing them (conversion to gray scale and contrast adjustment), segmenting cells and extracting features.
The output, saved in /mat/svm_dataset, contains features and labels to train the SVM classifier.

#### 3. Fit the SVM classifier
Run svmFitModel.m to train the SVM model, this will be saved in /mat/cp_ecoc_model.

#### 4. Predict cells / images labels
svmPredict.m will predict labels using the model trained before.
Results and confusion matrices will be produced both at cell and image level.