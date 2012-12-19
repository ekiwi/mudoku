function interpolation(array)

[height width] = size(array)

for i=1:height
    for j=1:width
        if(isnan(array(i,j)))
            display('Found');
            a = i;
            while(isnan(array(i+1,j)))
               i=i+1;
            end
            middle=(array(i+1,j)+array(a-1,j))*0.5;
            for c=a:i
                array(c,j)=middle;
            end
        end
    end
end

array

end
