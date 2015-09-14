function mapsize = cc_get_mapsize()
% Determine the number of rows and cols in a SOM

prompt = {'Row Number', 'Column Number'};
dlg_title = 'Determine SOM map size';
num_lines = 1;
defaultans = {'5', '5'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

nRow = str2double(answer{1});
nCol = str2double(answer{2});

mapsize = [nRow, nCol];

end