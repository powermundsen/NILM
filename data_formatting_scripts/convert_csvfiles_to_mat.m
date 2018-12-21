% This script will create .mat files of the data so that the NILM-eval kit
% can process it. The dats should be placed in /data/powermundsen_data/

current_directory = pwd;
% Setting paths to data
path_smart_plugs = fullfile(current_directory, '/data/powermundsen_data/plugs/');
path_smart_meter = fullfile(current_directory, '/data/powermundsen_data/smartmeter/');
sp_households = string.empty();
sm_households = string.empty();
plugs = string.empty();
meters = string.empty();

% Finding household folders for plugs
files = dir(path_smart_plugs);
dirFlags = [files.isdir] & ~strcmp({files.name},'.') & ~strcmp({files.name},'..');
subFolders = files(dirFlags);
disp('Households for smart plugs found: ');
for k = 1 : length(subFolders)
  sp_households = [sp_households, subFolders(k).name];
  fprintf('Household #%d = %s\n', k, subFolders(k).name);
end

% Finding plugs
files = dir(strcat(path_smart_plugs, sp_households{1}));
dirFlags = [files.isdir] & ~strcmp({files.name},'.') & ~strcmp({files.name},'..');
subFolders = files(dirFlags);
disp('Smart plugs found: ');
for k = 1 : length(subFolders)
  plugs = [plugs, subFolders(k).name];
  fprintf('Plug #%d = %s\n', k, subFolders(k).name);
end

% Iterate through smart plug folders to make mat-files
disp('Start: Iterate through smart plug folders to make mat-files')
for h = 1 : length(sp_households)
    for p = 1 : length(plugs)
        
        % Setting variables
        household = char(sp_households(h));
        plug = char(plugs(p));
        csv_files = string.empty();
        fprintf("Working on household %s plug %s \n", household, plug)
        folder = fullfile(path_smart_plugs, household, plug);
        
        % Finding dates
        files = dir(folder);
        dirFlags = ~strcmp({files.name},'.') & ~strcmp({files.name},'..');
        subFolders = files(dirFlags);
        for k = 1 : length(subFolders)
            if endsWith(subFolders(k).name, '.csv')
                csv_files = [csv_files, subFolders(k).name];
            end
            %fprintf('Date %s \n', k, subFolders(k).name);
        end
        fprintf('Date found %s \n', csv_files)
        
        % Importing CSV
        for k = 1: length(csv_files)
            fprintf('%s : Reading CSV file for plug: %s\n', csv_files(k), plug);
            filepath = fullfile(folder, char(csv_files(k)));
            [file_path_function, name, ext] = fileparts(filepath);
            consumption = csvread(filepath,0,1);
            
            % The following code is added to replace '-1' values
            % inbetween readings with last known value if less than 100 in a row
            counter = 0;
            for i = 2: length(consumption)
                if consumption(i)== -1 && counter ~= 100
                    counter = counter + 1;
                    consumption(i) = consumption(i-1);
                else
                    counter = 0;
                end
            end
            
            
            % Making struct
            % Variables
            date = regexprep(csv_files(k),'[-]','');
            date = regexprep(date, '[.csv]', '');
            struct_filename = char(strcat('Appliance', household, plug, date));
            consum = consumption;

            % Creating main struct 
            s = struct();
            % Creating struct for text variables
            j = struct();

            % Adding data to main struct
            s.household = household;
            s.plug = plug;
            s.consumption = consumption;
            
            % Solving the naming problem
            j = struct(struct_filename, s);

            % Exporting to .mat file
            %name = '2018-11-09';
            name = regexprep(csv_files(k), '[.csv]', '');
            filename = strcat(name, '.mat');
            savepath = strcat(file_path_function, '/', filename);
            save(savepath, '-struct', 'j');
            fprintf('Saved file \n');

            % Showing the contents 
            %whos(filepath, '2018-11-09.mat')
            
        end    
    end
end


% Finding household folders for smart meters
folders = dir(path_smart_meter);
dirFlags = [folders.isdir] & ~strcmp({folders.name},'.') & ~strcmp({folders.name},'..');
subFolders = folders(dirFlags);
disp('Households for smart meter found: ');
for k = 1 : length(subFolders)
  sm_households = [sm_households, subFolders(k).name];
  fprintf('Household #%d = %s\n', k, subFolders(k).name);
end

% Finding dates
disp('Iterating through households');
for h = 1 : length(sm_households)
    fprintf('Household %s : Started \n', sm_households(h));
    household = subFolders(k).name;
    folder = fullfile(path_smart_meter, household);
    sm_folders = dir(folder);
    dirFlags = [sm_folders.isdir] & ~strcmp({sm_folders.name},'.') & ~strcmp({sm_folders.name},'..');
    subFolders = sm_folders(dirFlags);
    fprintf('Household %s : Dates found \n', household);
    fprintf('%s, ', subFolders.name);
    
    % For each folder in subFolders
    for day = 1 : length(subFolders)
        fprintf('\n Household %s : Reading files for day %s \n', household, subFolders(day).name);
        
        % Variables
        date = subFolders(day).name;
        path_files = fullfile(folder, subFolders(day).name);
        filepath = fullfile(folder,char(subFolders(day).name));
        [file_path_function, name, ext] = fileparts(filepath);
        
        % Creating main struct
        s = struct();
        
        % Saving files to main struct
        s.powerallphases = csvread(fullfile(path_files,'/powerallphases.csv'),0,1);
        s.powerl1 = csvread(fullfile(path_files,'/powerl1.csv'),0,1);
        s.powerl2 = csvread(fullfile(path_files,'/powerl2.csv'),0,1);
        s.powerl3 = csvread(fullfile(path_files,'/powerl3.csv'),0,1);
        s.currentneutral = csvread(fullfile(path_files,'/currentneutral.csv'),0,1);
        s.currentl1 = csvread(fullfile(path_files,'/currentl1.csv'),0,1);
        s.currentl2 = csvread(fullfile(path_files,'/currentl2.csv'),0,1);
        s.currentl3 = csvread(fullfile(path_files,'/currentl3.csv'),0,1);
        s.voltagel1 = csvread(fullfile(path_files,'/voltagel1.csv'),0,1);
        s.voltagel2 = csvread(fullfile(path_files,'/voltagel2.csv'),0,1);
        s.voltagel3 = csvread(fullfile(path_files,'/voltagel3.csv'),0,1);
        s.phaseanglevoltagel2l1 = csvread(fullfile(path_files,'/phaseanglevoltagel2l1.csv'),0,1);
        s.phaseanglevoltagel3l1 = csvread(fullfile(path_files,'/phaseanglevoltagel3l1.csv'),0,1);
        s.phaseanglecurrentvoltagel1 = csvread(fullfile(path_files,'/phaseanglecurrentvoltagel1.csv'),0,1);
        s.phaseanglecurrentvoltagel2 = csvread(fullfile(path_files,'/phaseanglecurrentvoltagel2.csv'),0,1);
        s.phaseanglecurrentvoltagel3 = csvread(fullfile(path_files,'/phaseanglecurrentvoltagel3.csv'),0,1);
        
        % The following code is added to remove '-1' values
        % inbetween readings if less than 100 in a row
        fields = fieldnames(s);
        for i = 1:numel(fields)
            counter = 0;
            for j = 2: length(s.(fields{i}))
                if s.(fields{i})(j)== -1 && counter ~= 100
                    counter = counter + 1;
                    s.(fields{i})(j) = s.(fields{i})(j-1);
                else
                    counter = 0;
                end
            end
        end

        s.household = household;
       
        % Creating second struct
        j = struct();

        % Solving the naming problem by nesting
        struct_filename = char(strcat('Appliance', household, '00', regexprep(date, '-', '')));
        j = struct(struct_filename, s);

        % Exporting to .mat file
        filename = strcat(date, '.mat');
        savepath = strcat(file_path_function, '/', filename);
        save(savepath, '-struct', 'j');
        fprintf('Saved file \n');
    end
end

disp('Finished processing all plugs and households');


