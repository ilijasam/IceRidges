%       this script is reading the raw Beaufort Gyre Upward Looking Sonar data and writing into a .mat file
%       On date 02.02.2023, the data was available here: https://www2.whoi.edu/site/beaufortgyre/data/mooring-data/

clear all

addpath('Supporting Files\') % loading folder containing supporting scripts

cf = pwd;   % reading current folder in order to be able to go back to it once the script is done (last line)
df = 'D:\Moorings'; % specifing the folder containing the mooring data ()

%% looping throungh the years
for year = 2013
   cd(fullfile(df, [num2str(year),'-',num2str(year+1)])) % opening folder with year's data (e.g., "D:\Moorings\2017-2018")
   listing = dir; % reading data files available
   
   no_files = length(listing)-2;
   
   % looping through the files for a given year
   for file = 1:no_files

        fid = fopen(listing(file+2).name);
        c = textscan(fid,'%d %d %f','HeaderLines', 2 );

        %     read the date, time and data from file
        date = c{1};
        time = c{2};
        Data.draft = c{3};

        %     write the date and time in string arrays
        string_date = sprintf('%i',date);
        string_date = reshape(string_date,8,[])';
        string_time = sprintf('%06i',time);
        string_time = reshape(string_time,6,[])';

        %     merge and write date-time in string array
        N = length(date);

        str = [ string_date(:,1:4) repmat('-',N,1) string_date(:,5:6) repmat('-',N,1) string_date(:,7:8) repmat(' ',N,1) ...
        string_time(:,1:2) repmat(':',N,1) string_time(:,3:4) repmat(':',N,1) string_time(:,5:6)];

        %     get the datenum format of datetime
        dateNUM = DateStr2Num(cellstr(str),31);

        %     write the datetime string to datenum format
        Data.dateNUM = dateNUM;

        %     save the header line and file name in the struct file
        frewind(fid);
        Data.tline = fgets(fid);
        Data.file_name = listing(file+2).name;
        %     save the .mat file of the extracted data to the defined folder
        save(['D:\Moorings\test\' Data.file_name(1:end-4) '.mat'],'Data' )
        %     display the year and the file step
        disp(['File  :  ' num2str(file) ' / ' num2str(no_files) '    |    ' 'Year  :  ' num2str(year)])
   end   

end

cd(cf) % returining to the coding folder