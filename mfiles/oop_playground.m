classdef Dish
    methods( Abstract )
        cook(obj)
        serve(obj)
    end
end

classdef Hamburger < Dish
    methods
        function cook(obj)
            disp( 'Fire up the grill' )
        end

        function serve(obj)
            disp ('Here is your burger' )
        end
    end
end

classdef Salad < Dish
    methods
        function cook(obj)
            disp ('Add the dressing')
        end

        function serve(obj)
            disp ('Here is your salad')
        end
    end
end

% create a bunch of Dish objects
t = { Hamburger Hamburger Salad }

% cook each one
cellfun( @(x) cook(x), t )

% now serve each one
cellfun( @(x) serve(x), t )