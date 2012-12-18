function [ ] = disp_sudoku( sudoku )
%DISP_SUDOKU Displays sudoko on command line

s = size(sudoku);
if s(1) < 1 || s(2) < 1
    error('Sudoku too small!');
end

for x = 1:s(1)
    for line = 1:4
        for y = 1:s(2)
            if line == 1
                    fprintf('+===');
            elseif line == 3
                    fprintf('| %d ', sudoku(x,y));
            else
                    fprintf('|   ');
            end
            
        end
        % draw right line
        if y == s(2)
            if line == 1
                fprintf('+');
            else
                fprintf('|');
            end
        end
        % new line
        fprintf('\n');
    end
end

% draw bottom line
for y = 1:s(2)
    fprintf('+===');
end
fprintf('+\n');

end

