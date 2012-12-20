function [array] = interpolation(array)

[height width] = size(array);

% Erste Spalte NaN
for i=1:width
    if(isnan(array(1,i)))
        b=1;
        while(isnan(array(b,i)))
            b=b+1;
            if((b+1)>height)
                % Komplette Spalte NaN
                % ADD
            end
        end
        for j=1:b
            array(j,i)=array(b+1,i);
        end
    end
end

% Letzte Spalte NaN
for i=1:width
    if(isnan(array(height,i)))
        b=height;
        while(isnan(array(b,i)))
            b=b-1;
            if((b-1)<1)
                % Komplette Spalte NaN
                % ADD
            end
        end
        letzteStelleNaN = b+1;
        for j=height:-1:letzteStelleNaN
            array(j,i)=array(letzteStelleNaN-1,i);
        end
    end
end
        
% Zwischendrin NaN
for i=1:height
    for j=1:width
        if(isnan(array(i,j)))
            ersteStelleNaN = i;
            b = i;
            while(isnan(array(b,j)))
               b=b+1;
            end
            letzteStelleNaN = b-1;
            middle=(array(letzteStelleNaN+1,j)+array(ersteStelleNaN-1,j))*0.5;
            for c=ersteStelleNaN:letzteStelleNaN
                array(c,j)=middle;
            end
        end
    end
end

end
