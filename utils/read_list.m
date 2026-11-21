function list = read_list(txt_file)
% READ_LIST  Read a text file with one path per line into a cell array.
fid = fopen(txt_file);
if fid < 0, error('Cannot open list file: %s', txt_file); end
c = textscan(fid, '%s');
fclose(fid);
list = c{1};
end
