% HEp2 cells classification
% Configuration file

classdef configuration
   properties (Constant)     
       
       % Image files path
       image_path = '../HEp-2CellsClassification/dataset/immagini_contest/';
       image_prefix = 'Siero_';
       image_ext = 'bmp';
       
       % Dataset file
       % Supported formats: xls, xlsx, csv 
       validation_format = 'xlsx';      
       validation_file = 'dataset/Validation_set.xlsx';
       validation_file_worksheet_name = 'Lavoro';
       validation_file_image_ids_column = 3;
       validation_file_image_label_column = 6;
       
       % Patterns
       % List here cell classes with their ID in the dataset file
       patterns = containers.Map( ...
             {1, 2, 3, 5, 6, 7}, ...
             {'Homogeneous', 'Speckled', 'Nucleolar', 'Citoplasmic', 'Negative', 'Granular'});
       
       % Gabor Filter options
       Gabor_options = struct(...
           'Width', 11, ...
           'num_theta', 4, ...
           'num_scale', 3, ...
           'show_plot', false);
       
       % Features Extraction options
       % If concatExtraFeatures=true, two Gabor vectors will be extracted
       % applying top hat with radius respectively A and B
       concatExtraFeatures = false;
       topHatRadiusA = false;
       topHatRadiusB = false;
       
       %SVM kFolds for cross-validation
       kFolds = 8;
       
   end
end