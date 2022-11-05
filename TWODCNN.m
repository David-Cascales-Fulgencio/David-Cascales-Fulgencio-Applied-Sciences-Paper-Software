function [net] = TWODCNN(inputArg1)

%'TWODCNN' is the 2D Convolutional Neural Network (CNN) proposed in [1] for
%the automatic classification of images from vibration signals captured with an
%accelerometer carrying information about the health status of Rolling
%Element Bearings (REBs).

%Input description

    %'inputArg1' is an image data store containing healthy and faulty
    %REBs' signal images obtained through the 'Images_Generator' function.
    
%Reference

    %[1] Cascales Fulgencio, D.; Quiles Cucarella, E.; García Moreno, E.
    %Computation and Statistical Analysis of Bearings’ Time- and
    %Frequency-Domain Features Enhanced Using Cepstrum Pre-Whitening: A ML-
    %and DL-Based Classification.
    %Appl. Sci. 2022.

%------------------------------
%Author: David Cascales Fulgencio
%Last revision: 17/09/2022
%------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Specify the images' size

imageSize = [50 50 1];

%Specify training and validation sets

[imdsTrain,imdsValidation] = splitEachLabel(inputArg1,0.8,0.2,'randomize');

%Define network architecture

layer = [
    imageInputLayer(imageSize) % Input layer (image size).
    
    convolution2dLayer(5,5,'Padding','same') % First convolutional layer using a [5x5] kernel ([Height Width]). The stride's size is [1 1] by default ([a b]), where 'a' is the vertical step size and 'b' is the horizontal step size. The software automatically calculates the padding's size at training time so that the output has the same size as the input.
    batchNormalizationLayer % A batch normalisation layer normalizes a mini-batch of data across all observations for each channel independently to speed up the convolutional neural network's training.
    reluLayer % Activation function ReLU to overcome the issue of vanishing gradients.
    
    maxPooling2dLayer(2,'Stride',2) % [2x2] pooling layer ([Height Width]), to reduce the first convolutional layer's output size. The stride's size is [2 2] ([a b]), where 'a' is the vertical step size and 'b' is the horizontal step size. The padding's size is set to zero by default.
    
    convolution2dLayer(5,5,'Padding','same') % Second convolutional layer.
    batchNormalizationLayer
    reluLayer 
    
    maxPooling2dLayer(2,'Stride',2) % Second pooling layer.
    
    fullyConnectedLayer(4) % Fully connected layer of 4 neurons (one per class).
    softmaxLayer % Softmax layer to apply a softmax function to the input.
    classificationLayer]; % Output layer.

%Specify training options
    
option = trainingOptions('sgdm', ... % The network will be trained using the Stochastic Gradient Descent with Momentum (SDGM) method.
    'InitialLearnRate',0.01, ... % The learning rate determines the size of an update.
    'MaxEpochs',15, ... % Set the maximum number of epochs to 15.
    'MiniBatchSize',35, ... % Each epoch will be done in NTrain/35 iterations. Each iteration will include 35 training samples passed through the model.
    'Shuffle','every-epoch', ... % Shuffle the training data before each training epoch and shuffle the validation data before each network validation.
    'ValidationData',imdsValidation, ... % Define data to use for validation during training.
    'ValidationFrequency',50, ... % Frequency of network validation in 50 iterations.
    'Verbose',false, ... % Indicator not to display training progress information in the command window.
    'Plots','training-progress'); % Indicator to display training progress information in the plot.

%Train network using training data

net = trainNetwork(imdsTrain,layer,option);

end