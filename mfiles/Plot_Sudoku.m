function [ ] = Plot_Sudoku(sudoku)
%PLOT_SUDOKU Summary of this function goes here
%Plot the Sudoku in Numbers
figure;
grid on;
set(gca, 'GridLineStyle', '-');
hold all;
title('SUDOKU');
axis([0,9,0,9]);
 
for x=1:9
    for y=1:9
        if(sudoku(x,y)~=0)
            t=text(-1+y+0.5,9-x+0.5,num2str(sudoku(x,y)));
            set(t,'FontSize',15);
        end
    end
end
end

