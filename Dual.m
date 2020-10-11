classdef Dual %< matlab.mixin.CustomDisplay
    %DUAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        f {mustBeNumeric}
        df {mustBeNumeric}
    end
    
    methods
        function obj = Dual(f,df)
            %DUAL Construct an instance of this class
            %   Detailed explanation goes here
            obj.f = f;
            if nargin == 1
               obj.df = 0;
            else
               obj.df = df;
            end
        end
        
        
        
        function o = plus(o1,o2)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            if isnumeric(o2)
                o = Dual(o1.f + o2,o1.df);
            elseif isnumeric(o1)
                o = Dual(o2.f + o1,o2.df);
            else
                o = Dual(o1.f + o2.f , o1.df + o2.df);
            end
        end
        
        function o = minus(o1,o2)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            if isnumeric(o2)
                o = Dual(o1.f - o2,o1.df);
            elseif isnumeric(o1)
                o = Dual(o1-o2.f,o2.df);
            else
                o = Dual(o1.f - o2.f , o1.df - o2.df);
            end
        end
        
        function o = times(o1,o2)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            if isnumeric(o2)
                o = Dual(o1.f * o2,o1.df);
            elseif isnumeric(o1)
                o = Dual(o1*o2.f,o2.df);
            else
                o = Dual(o1.f * o2.f , o1.df*o2.f + o1.f*o2.df);
            end
        end
        
        
        function o = mtimes(o1,o2)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            if isnumeric(o2)
                o = Dual(o1.f * o2,o1.df);
            elseif isnumeric(o1)
                o = Dual(o1*o2.f,o2.df);
            else
                o = Dual(o1.f * o2.f , o1.df*o2.f + o1.f*o2.df);
            end
        end
        
        function o = power(o1,o2)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            if class(o2)=="Dual"
                error("Dual numbers cannot be exponents");
            else
                o = Dual(o1.f^o2 , o2*(o1.f)^(o2-1)*o1.df);
            end
        end
        
        function o = sin(o1)
           o = Dual(sin(o1.f),cos(o1.f)*o1.df); 
        end
        
        
        function d = double(o1)
           d = double(o1.f); 
        end
        
        function disp(obj)
            if obj.df==0
                disp(obj.f);
            elseif obj.df==1
                fprintf("%s\n", num2str(obj.f) +" + e");
            elseif obj.df>0
                fprintf("%s\n", num2str(obj.f) +" + " +num2str(obj.df) + "e");
            elseif obj.df==-1
                fprintf("%s\n", num2str(obj.f) +" - e");
            else
                fprintf("%s\n", num2str(obj.f) +" - " +num2str(abs(obj.df)) + "e");
            end            
        end
        
    end
%     
%     methods (Access=protected)
%        function header  = getHeader(o)
%             headerStr = matlab.mixin.CustomDisplay.getClassNameForHeader(o);
%             headerStr = [headerStr,' number '];
%             header = sprintf('%s\n',headerStr);
%        end 
%        function propgrp = getPropertyGroups(obj)
%          propList = struct("f",num2str(obj.f));
%          propgrp = matlab.mixin.util.PropertyGroup(propList);
%        end
%     end
end

