 function loadTrainingSet ()
%Load training set labels from CSV file and generate a mat file

    import configuration.*;
    addpath('./utils');
             
    %Read validation set
    file_ext = configuration.validation_format;
    ids_column = configuration.validation_file_image_ids_column;
    label_column = configuration.validation_file_image_label_column;
    
    if(strcmp(file_ext, 'csv') == 1)
        %Read from csv
        validation_set = readCSV(configuration.validation_file, ';');
        validation_set = validation_set(2:end, :);
        validation_labels_id = validation_set(2:end, label_column);
        counter = 1;
        for l = 1:length(validation_labels_id)
            pattern_id = str2double(validation_labels_id(l));
            if(isKey(configuration.patterns, pattern_id))
                validation_labels{counter} = configuration.patterns(pattern_id);
                image_ids(counter) = validation_set(l, ids_column);
                counter = counter + 1;
            end
        end          
    else
        %Read from xls/xlsx
        validation_set = xlsread(configuration.validation_file, ...
            configuration.validation_file_worksheet_name);
        validation_labels_id = validation_set(:, label_column);

    end
    
    counter = 1;
    for l = 1:length(validation_labels_id)
        if(iscellstr(validation_labels_id(l)))
            pattern_id = str2double(validation_labels_id(l));
        else
            pattern_id = validation_labels_id(l);
        end
          
        if(isKey(configuration.patterns, pattern_id))
            validation_labels{counter} = configuration.patterns(pattern_id);
            image_ids(counter) = validation_set(l, ids_column);
            counter = counter + 1;
        end
    end

    filenames = cell(length(validation_labels), 1);    
    trainSet = cell(length(validation_labels), 2);
    for i = 1:length(validation_labels) 
        if(isnumeric(image_ids(i)))
            filename_id = int2str(image_ids(i));
        else
            filename_id = image_ids(i);
        end
        filename = strcat(configuration.image_path, configuration.image_prefix, ...
            filename_id, '.', configuration.image_ext);       
        
        if(exist(char(filename), 'file') ~= 2)
           warning('Image %s not found. Will not be processed.\n', char(filename));
        end
                
        if(ischar(filename))
            filename = cellstr(filename);
        end

        filenames(i) = filename;
        
        trainSet{i, 1} = image_ids(i);
        trainSet{i, 2} = char(validation_labels(i));
        trainSet{i, 3} = char(filename);   
    end

    table(image_ids', validation_labels', filenames, ...
    'VariableNames', {'ID', 'Label', 'Filename'})
    
    mkdir('./mat');
    save('./mat/trainSet', 'trainSet');
    
    fprintf('Training Set saved correctly!\n\n');
end