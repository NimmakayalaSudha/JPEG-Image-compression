Cclc;
img = imread('1.jpg');
[row1 col1]=size(img);
img = imresize((img),[256 256]);
[ row, col] =size(img);
imgTrans=img;
% 1D conversion
img1D = imgTrans(:);
% Decimal to Hex value conversion
imgHex = dec2hex(img);
% New txt file creation
fid = fopen('1.txt', 'w');
% Hex value write to the txt file
fprintf(fid, '%x\n', img1D);
% Close the txt file
fclose(fid);