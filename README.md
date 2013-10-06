Digit-Recognizer
================

Built a complete digit recognizer in python and matlab using feature extraction (and applying k-nn algorithm) and linear discriminant functions.

a) Feature Extraction (Using Python) :

Built a complete digit recognizer and tested it on the MNIST digit dataset. The recognizer read the image data, 
extracted features from it and used k-nearest neighbor classifier to recognize any test image. Finally the accuracy of each 
feature was calculated by testing it on the test data.

The k-NN algorithm used the following features-

1) Counting number of 1's in each row : It constructed a feature vector of 1 X 28 dimensions storing the total count 
   of one's in each row.
2) Pixel Difference: It constructed a feature vector of 1 X 784 dimensions storing the pixel value of the given image.
3) Concavities Measurement: It divided the image into 4 zones each one obtaining its own feature vector of 5 dimension.
   This feature calculated the number of white pixels which encountered 0, 1, 2, 3 or 4 back pixels when moved in 4 
   directions. Thus finally a 20 X 1 dimension vector was created.
4) Zoning: It divided the image into 7 X 7 matrices and calculated ((the total number of ones in each zone)/area of matrix)
   *100. Therefore a matrix of 1 X 49 dimension was created.
5) Orientation: It calculated number of ones in every direction (seperated by angle 45 degree) and it resulted into a 
   vector of 1 X 8 vector.
6) Multi Zoning: It divided the given 28 X 28 matrix into 2 X 2, 4 X 4, 7 X 7 and 14 X 14 matrices and applied zoning 
   method on eack subpart. It resulted into the formation of 1 X 265 dimension vector.


b) Used Algorithms to find linear discriminant functions (Using matlab) : 

Built a digit recognizer and tested it on the following datasets -

1) Synthetic 2-class data-points (MS2CD)
2) MNIST subset data

Finally the accuracy of each algorithm was calculated by testing it on the test data.

The project aimed at finding linear discriminant functions using following algorithms - 

1) Batch Perceptron Algorithm
2) Single Sample Perceptron Algorithm
3) Batch Perceptron with margin Algorithm
4) Single Sample Perceptron with margin Algorithm
5) Batch Relaxation with margin Algorithm

The multiclass problem was handled by using Pairwise Classification (One vs One Classification) with Majority Voting.
