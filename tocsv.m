% Open the txt file for reading
fid = fopen('input.txt.txt', 'r');

% Create an empty cell array to store the data
data = {};

% Loop through each line of the txt file and store it in the data array
while ~feof(fid)
    line = fgetl(fid);
    data{end+1} = line;
end

% Close the txt file
fclose(fid);

% Convert the data array to a matrix
data_matrix = cellfun(@(x) str2double(strsplit(x)), data, 'UniformOutput', false);

% Convert the matrix to a table
data_table = cell2table(data_matrix);

% Write the table to a CSV file with space as delimiter
writetable(data_table, 'output.csv', 'Delimiter', ' ');
