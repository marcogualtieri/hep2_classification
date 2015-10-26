%Project configuration file

classdef configuration
   properties (Constant)       
       % Image path
       image_path = '../HEp-2CellsClassification/dataset/immagini_contest/';
       image_prefix = 'Siero_';
       image_ext = 'bmp';
       
       % Validation file for training
       % Choose the validation format xls, xlsx, csv (xls not work on Unix,
       % use xlsx or cvs instead)
       validation_format = 'xlsx';      
       validation_file = 'dataset/Validation_set.xlsx';
       validation_file_worksheet_name = 'Lavoro';
       validation_file_image_ids_column = 3;
       validation_file_image_label_column = 6;
       
       % Patterns
        patterns = containers.Map( ...
            {1, 2, 3, 5, 6, 7}, ...
            {'Omogeneo', 'Punteggiato', 'Nucleolare', 'Citoplasmico', 'Negativo', 'Granulare'});
              
       % Gabor Filter options
       Gabor_options = struct(...
           'Width', 11, ...
           'num_theta', 4, ...
           'num_scale', 3, ...
           'show_plot', false);
       
       % Features Extraction options
       concatExtraFeatures = true;
       topHatRadiusA = false;
       topHatRadiusB = 30;
       
       %SVM kFolds for cross-validation
       kFolds = 8;
   end
end