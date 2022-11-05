function [SECTIONS, MATRICES, IMAGES] = Images_Generator(inputArg1, inputArg2, inputArg3)

%'Images_Generator' transforms a series of vibration signals captured with
%an accelerometer carrying information about the health status of Rolling
%Element Bearings (REBs) into 48 images/signal and stores them into several
%folders to be defined according to the REBs' health status.

%Inputs' description

    %'inputArg1' is a cell array containing healthy and faulty REBs'
    %time-domain vibration signals. Faults are located on the inner race,
    %outer race and balls.
    
    %'inputArg2' is a cell array of the same dimensionality as the latter,
    %containing labels for each type of signal ('0' for healthy REBs, '1' for
    %REBs with inner race faults, '2' for REBs with faulty balls and '3' for
    %REBs with outer race faults), for later classification.
    
    %'inputArg3' is a cell array of the same dimensionality as the
    %latter, containing each signal's name for a proper storage.
    
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

%Define storage cell arrays

SECTIONS = cell(size(inputArg1,1),1);
MATRICES = cell(size(inputArg1,1),1);
IMAGES = cell(size(inputArg1,1),1);

%Define storage folders

folder_0 = 'D:\to be defined';
folder_1 = 'D:\to be defined';
folder_2 = 'D:\to be defined';
folder_3 = 'D:\to be defined';

%Extract 48 images from each raw time-domain signal

for i = 1:size(inputArg1,1)
    
    m = inputArg2{i};
    n = inputArg3{i};
    
    sections_i = cell(48,1);
    matrices_i = cell(48,1);
    images_i = cell(48,1);

    if m == 0
        
        for j = 1:48

            k = inputArg1{i};
            section_j = k(((2500*(j-1))+1):(2500*j));
            sections_i{j,:} = section_j;
            matrix_j = reshape(section_j,[50,50]);
            matrices_i{j,:} = matrix_j;
            image_j = mat2gray(matrix_j);
            images_i{j,:} = image_j;
            file_name = fullfile(folder_0, sprintf(strcat(n,'_%04d.jpg'), i,j));
            imwrite(image_j, file_name);

        end

    elseif m == 1
    
        for j = 1:48

            k = inputArg1{i};
            section_j = k(((2500*(j-1))+1):(2500*j));
            sections_i{j,:} = section_j;
            matrix_j = reshape(section_j,[50,50]);
            matrices_i{j,:} = matrix_j;
            image_j = mat2gray(matrix_j);
            images_i{j,:} = image_j;
            file_name = fullfile(folder_1, sprintf(strcat(n,'_%04d.jpg'), i,j));
            imwrite(image_j, file_name);

        end

    elseif m == 2
    
        for j = 1:48

            k = inputArg1{i};
            section_j = k(((2500*(j-1))+1):(2500*j));
            sections_i{j,:} = section_j;
            matrix_j = reshape(section_j,[50,50]);
            matrices_i{j,:} = matrix_j;
            image_j = mat2gray(matrix_j);
            images_i{j,:} = image_j;
            file_name = fullfile(folder_2, sprintf(strcat(n,'_%04d.jpg'), i,j));
            imwrite(image_j, file_name);

        end

    elseif m == 3
    
        for j = 1:48

            k = inputArg1{i};
            section_j = k(((2500*(j-1))+1):(2500*j));
            sections_i{j,:} = section_j;
            matrix_j = reshape(section_j,[50,50]);
            matrices_i{j,:} = matrix_j;
            image_j = mat2gray(matrix_j);
            images_i{j,:} = image_j;
            file_name = fullfile(folder_3, sprintf(strcat(n,'_%04d.jpg'), i,j));
            imwrite(image_j, file_name);

        end

    end
    
    SECTIONS{i,:} = sections_i;
    MATRICES{i,:} = matrices_i;
    IMAGES{i,:} = images_i;
    
end
        
end