function [filelist, names]=createfilelist(folder,subfoldersearch,fileType,CStyle)
% function filelist=createfilelist(folder,subfoldersearch,fileType,CStyle)
%
% This functions creates a list of files in a particular directory. It can
% also search all subdirectories.
%
% INPUT:
% folder          - path to folder (both C:\temp and c:\temp\ will be fine)
% subfoldersearch - if the algorithm should search subfolders as well 1/0 (on/off , default = 0 off)
% fileType        - type of files to search for (default = '*.m')
% CStyle          - If paths should be in C style or not (1/0) (default = off, c\temp in c-style would be c:\\temp)
%
% OUTPUT:
% filelist - struct array with 1 field:  
%            filelist.name (field is containing full path and filename)
%   
% For questions contact andrew tobiesen, sintef 2009.

% Checking input parameters
if nargin < 1
    disp('Usage: filelist=createfilelist(folder,subfoldersearch,fileType,CStyle)');
    return;
end
if nargin < 2
    subfoldersearch = 1;
    CStyle   = 0;
end
if nargin < 3
    fileType = '*.m';
end
if nargin < 4
    CStyle   = 0;
end

if folder(end) == '\'
    folder = folder(1:end-1);
end

if CStyle
    folderC = strrep(folder,'\','\\');    
else
    folderC = folder;
end

% Adding all files in first (or root) folder
fileCount = 1;
filelist = [];
file = dir([folder '\' fileType]);
if length(file) > 0
    [names{1:length(file)}] = deal(file.name);
    for i=1:length(names)
        if CStyle
            filelist{i} = [folderC '\\' names{i}];
        else
            filelist{i} = [folderC '\' names{i}];
        end
        fileCount = fileCount + 1;
    end
end

% Adding all files in subfolders
dirs = dir([folder '\']);
if length(dirs) > 0 
    [dirlist{1:length(dirs)}] = deal(dirs.name);
    
    for i=3:length(dirlist)
        if subfoldersearch
            if dirs(i).isdir
                newlist=createfilelist([folder '\' dirlist{i}],subfoldersearch,fileType,CStyle);
                for i=1:length(newlist)
                    filelist{fileCount} = newlist{i};
                    fileCount = fileCount + 1;
                end
            end
        end
    end
end


filelist = filelist';
