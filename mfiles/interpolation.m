function interpolation(array)

[height width] = size(array)

for i=1:height
    for j=1:width
        if(isnan(array(i,j)))
            ersteStelleNaN = i;
            while(isnan(array(i+1,j)))
               i=i+1;
            end
            letzteStelleNaN = i;
            middle=(array(letzteStelleNaN+1,j)+array(ersteStelleNaN-1,j))*0.5;
            for c=ersteStelleNaN:letzteStelleNaN
                array(c,j)=middle;
            end
        end
    end
end

array

end
