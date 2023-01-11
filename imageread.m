fileID = fopen('dctqfinal.txt','r');
A = fscanf(fileID,'%d');
fclose(fileID);
c=1;
d=[];
for l=0:8:120
    for k=0:8:120
        for j=1:1:8
            for i=1:1:8
              d(j+l,k+i)=(A(c));
              c=c+1;
        end
    end
    end
end
rc=uint8(d);
imshow(uint8((d)))