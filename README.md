# hep2_classification

Segmentate and classify HEp2 cells images.

Steps to run:

##### 1. Prepare the configuration file
Compile *configuration.m* file with proper values for files path and classes.

##### 2. Generate the dataset
The *createSvmDataset.m* script is responsible of loading images, preprocessing them (conversion to gray scale and contrast adjustment), segmenting cells and extracting features.

The output, saved in */mat/svm\_dataset*, contains features and labels to train the SVM classifier. Images without a class are marked as 'Unlabeled'.

#### 3. Fit the SVM classifier
Run *svmFitModel.m* to train an SVM model based on */mat/svm\_dataset*.

The trained model will be saved in */mat/cp\_ecoc\_model*.

#### 4. Predict images labels
The *svmPredict.m* script will predict labels for images listed in */mat/svm\_dataset* using the model stored in */mat/cp\_ecoc\_model*.

Results of prediction are saved in */mat/svm\_prediction\_results*.

#### 5. Show statistics of prediction
Run the *svmShowStats.m* script to display some statistics (accuracy rate, confusion matrix) computed on */mat/svm\_prediction\_results*.
