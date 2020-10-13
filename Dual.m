classdef Dual %< matlab.mixin.CustomDisplay
    %DUAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x {mustBeNumeric}
        d {mustBeNumeric}
        dd
    end
    
    methods
               % Constructor
%        function obj = Dual(x,d,dd)
         function obj = Dual(varargin)
            switch nargin
                case 2
                    o  = varargin{1};
                    p  = varargin{2};
                    r  = zeros(size(p));
                case 3
                    o  = varargin{1};
                    p  = varargin{2};
                    r  = varargin{3};
%                      o  = x;
%                      p  = d;
%                      r  = dd;
                otherwise
                    error('Unexpected inputs')
           end
                    
            if size(o,1) ~= size(p,1)||size(o,1)~= size(r,1) || size(o,2) ~= size(p,2)||size(o,2)~= size(r,2)
                error('DUAL:constructor','X, D and DD are different size')
            else
                obj.x  = o;
                obj.d  = p;
                obj.dd = r;
            end
        end
        % Getters
        function v = getvalue(a)
            v = a.x;
        end
        function dev = getderiv(a)
            dev = a.d;
        end
        function devs = getsderiv(a)
            devs = a.dd;
        end
        % Indexing
        function A = subsref(A,S)
            switch S.type
                case '()'
                    idx = S.subs;
                    switch length(idx)
                        case 1                           
                           A = Dual(A.x(idx{1}),A.d(idx{1}),A.dd(idx{1}));
                        case 2
                            A = Dual(A.x(idx{1},idx{2}), A.d(idx{1},idx{2}),A.dd(idx{1},idx{2}));
                        otherwise
                            error('Dual:subsref','Arrays with more than 2 dims not supported')
                    end
                case '.'
                    switch S.subs
                        case 'x'
                            A = A.x;
                        case 'd'
                            A = A.d;
                        case 'dd'
                            A = A.dd;
                        otherwise
                            error('Dual:subsref','Field %s does not exist',S.subs)
                    end
                otherwise
                    error('Dual:subsref','Indexing with {} is not supported')
            end
        end
        function A = subsasgn(A,S,B)
            switch S.type
                case '()'
                    idx = S.subs;
                otherwise
                    error('Dual:subsasgn','Assignment with {} and . not supported')
            end
            if ~isa(B,'Dual')
                B = mkdual(B);
              
            end
            switch length(idx)
                case 1
                    A.x(idx{1})  = B.x;
                    A.d(idx{1})  = B.d;
                    A.dd(idx{1}) = B.dd;
                case 2
                    A.x(idx{1},idx{2})  = B.x;
                    A.d(idx{1},idx{2})  = B.d;
                    A.dd(idx{1},idx{2}) = B.dd;
                otherwise
                    error('Dual:subsref','Arrays with more than 2 dims not supported')
            end
        end
        % Concatenation operators
        function A = horzcat(varargin)
            for k = 1:length(varargin)
                tmp = varargin{k};
                xs{k} = tmp.x;
                ds{k} = tmp.d;
                dds{k}= tmp.dd;
            end
            A = Dual(horzcat(xs{:}), horzcat(ds{:}),horzcat(dds{:}));
        end
        function A = vertcat(varargin)
            for k = 1:length(varargin)
                tmp = varargin{k};
                xs{k} = tmp.x;
                ds{k} = tmp.d;
                dds{k} = tmp.dd;
            end
            A = Dual(vertcat(xs{:}), vertcat(ds{:}),vertcat(dds{:}));
        end
        % Plotting functions
        function plot(X,varargin)
            if length(varargin) < 1
                Y = X;
                X = 1:length(X.x);
            elseif isa(X,'Dual') && isa(varargin{1},'Dual')
                Y = varargin{1};
                varargin = varargin(2:end);
            elseif isa(X,'Dual')
                Y = X;
                X = 1:length(X);
            elseif isa(varargin{1},'Dual')
                Y = varargin{1};
                varargin = varargin(2:end);
            end
            if isa(X,'Dual')
                plot(X.x,[Y.x(:) Y.d(:) Y.dd(:)],varargin{:})
            else
                plot(X,[Y.x(:) Y.d(:) Y.dd(:)],varargin{:})
            end
            grid on
            legend({'F','Fx','Fxx'})
        end
        % Comparison operators
        function res = eq(a,b)
            if isa(a,'Dual') && isa(b,'Dual')
                res = a.x == b.x;
            %    res = a == b;
            elseif isa(a,'Dual')
                res = a.x == b;
            elseif isa(b,'Dual')
                res = a == b.x;
            end
        end
        function res = neq(a,b)
            if isa(a,'Dual') && isa(b,'Dual')
                res = a.x ~= b.x;
               % res = a.x ~= b.x;
%                res = a.x ~= b.x && a.d ~= b.d && a.dd ~= b.dd ;
            elseif isa(a,'Dual')
                res = a.x ~= b;
            elseif isa(b,'Dual')
                res = a ~= b.x;
            end
        end
        function res = lt(a,b)
            if isa(a,'Dual') && isa(b,'Dual')
               res = a.x < b.x;
              % res = a < b;
%               res = a.x < b.x && a.d < b.d && a.dd < b.dd ;
            elseif isa(a,'Dual')
                res = a.x < b;
            elseif isa(b,'Dual')
                res = a < b.x;
            end
        end
        function res = le(a,b)
            if isa(a,'Dual') && isa(b,'Dual')
               res = a.x <= b.x;
             %  res = a <= b;
%              res = a.x <= b.x && a.d <= b.d && a.dd <= b.dd ;
            elseif isa(a,'Dual')
                res = a.x <= b;
            elseif isa(b,'Dual')
                res = a <= b.x;
            end
        end
        function res = gt(a,b)
            if isa(a,'Dual') && isa(b,'Dual')
                res = a.x > b.x;
              %  res = a > b;
%               res = a.x > b.x && a.d > b.d && a.dd > b.dd ;
            elseif isa(a,'Dual')
                res = a.x > b;
            elseif isa(b,'Dual')
                res = a > b.x;
            end
        end
        function res = ge(a,b)
            if isa(a,'Dual') && isa(b,'Dual')
             %   res = a.x >= b.x && a.d >= b.d && a.dd >= b.dd ;
                res = a.x >= b.x;
              %  res = a >= b;
            elseif isa(a,'Dual')
                res = a.x >= b;
            elseif isa(b,'Dual')
                res = a >= b.x;
            end
        end
        function res = isnan(a)
            
            res = isnan(a.x);
          %  res = isnan(a);
        end
        function res = isinf(a)
            
            res = isinf(a.x);
          %  res = isinf(a);
        end
        function res = isfinite(a)
            res = isfinite(a.x);
          %  res = isfinite(a);
        end
        % Unary operators
        function obj = uplus(a)
            obj = a;
        end
        function obj = uminus(a)
            %obj = -a;
            obj = Dual(-a.x, -a.d, -a.dd);
        end
        function obj = transpose(a)
            obj = Dual(transpose(a.x), transpose(a.d), transpose(a.dd));
        end
        function obj = ctranspose(a)
            obj = Dual(ctranspose(a.x), ctranspose(a.d), ctranspose(a.dd));
        end
        function obj = reshape(a,ns)
            obj = Dual(reshape(a.x,ns), reshape(a.d,ns), reshape(a.dd,ns));
        end
        % Binary arithmetic operators
        function obj = plus(a,b)
            if isa(a,'Dual') && isa(b,'Dual')
                obj = Dual(a.x + b.x, a.d + b.d, a.dd + b.dd);
            elseif isa(a,'Dual')
                obj = Dual(a.x + b, a.d, a.dd);
            elseif isa(b,'Dual')
                obj = Dual(a + b.x, b.d, b.dd);
            end
        end
        function obj = minus(a,b)
            if isa(a,'Dual') && isa(b,'Dual')
                obj = Dual(a.x - b.x, a.d - b.d, a.dd - b.dd);
            elseif isa(a,'Dual')
                obj = Dual(a.x - b, a.d, a.dd);
            elseif isa(b,'Dual')
                obj = Dual(a - b.x, -b.d, -b.dd);
            end
        end
        function obj = times(a,b)
            if isa(a,'Dual') && isa(b,'Dual')
                ddpart = a.dd.*b.x+2*b.d.*a.d+b.dd.*a.x;
                %ddpart = 2*b.d.*a.d;
               
                obj = Dual(a.x .* b.x, a.x .* b.d + a.d .* b.x, ddpart);
            elseif isa(a,'Dual')
                obj = Dual(a.x .* b, a.d .* b, a.dd .* b);
            elseif isa(b,'Dual')
                obj = Dual(a .* b.x, a .* b.d, a .* b.dd);
            end
        end
        function obj = mtimes(a,b)
            % Matrix multiplication for dual numbers is elementwise
            obj = times(a,b);
        end
        
        function obj = rdivide(a,b)
            if isa(a,'Dual') && isa(b,'Dual')
                xpart    = a.x ./ b.x;
                dpart    = (a.d .* b.x - b.d.*a.x) ./ (b.x .* b.x);
                denmnatr = (b.x .* b.x).*(b.x .* b.x);
                f_part   = (a.dd.*b.x+a.d.*b.d).*b.x.*b.x - a.d.*b.x.*2.*b.x.*b.d;
                s_part   = (b.dd.*a.x+b.d.*a.d).*b.x.*b.x - b.d.*a.x.*2.*b.x.*b.d;
                partSec  = (f_part - s_part)./denmnatr;
                obj = Dual(xpart,dpart,partSec);
            elseif isa(a,'Dual')
                obj = Dual(a.x./ b, a.d./ b, a.dd./b);
            elseif isa(b,'Dual')
                oD = -(a.*b.dd.*b.x.*b.x - a.*b.d.*2.*b.x.* b.d);
                odN = (b.x .* b.x).*(b.x .* b.x);
                ot = oD./odN;
                obj = Dual(a ./ b.x, -(a .* b.d) ./ (b.x .* b.x), ot);
            end
        end
        function obj = mrdivide(a,b)
            % All division is elementwise
            obj = rdivide(a,b);
        end
         function obj = power(a,b)
            % n is assumed to be a real value (not a dual)
            if isa(a,'Dual') && isa(b,'Dual')
                Pb = (b.d.*log(a.x)+ b.x.*(a.d./a.x));
                Pd = power(a.x,b.x);
                Paa = Pd.*Pb.*Pb + Pd.*(b.dd.*log(a.x) + 2*b.d.*a.d./a.x + b.x.*(a.dd.*a.x-a.d.*a.d)./(a.x.*a.x));
                obj = Dual(power(a.x,b.x),power(a.x,b.x).*(b.d.*log(a.x)+ b.x.*(a.d./a.x)), Paa);
                %error('Dual:power','Power is not defined for a and b both dual')
            elseif isa(a,'Dual')
                
                obj = Dual(power(a.x,b), b .* a.d .* power(a.x,b-1),b.*(a.dd.*power(a.x,b-1)+(b-1).*a.d.*a.d.*power(a.x,b-2)));
            elseif isa(b,'Dual')
                ab  = power(a,b.x);
                ac  = b.d .* log(a) .* ab;
                add = log(a).*(b.dd.*ab + ac.*b.d);
                obj = Dual(ab, ac, add);
            end
        end
        function obj = mpower(a,n)
            % Elementwise power
            obj = power(a,n);
        end
        % Miscellaneous math functions
        function obj = sqrt(a)
            obj = power(a,0.5);
%             asq = 0.5*a.dd./sqrt(a.x)-0.25*a.d./(a.x.*sqrt(a.x));
%             obj = Dual(sqrt(a.x), a.d ./ (2 * sqrt(a.x)),asq);
        end
        function obj = abs(a)
            obj = Dual(abs(a.x), a.d .* sign(a.x), a.dd.*sign(a.x).*sign(a.x));
        end
        function obj = sign(a)
            % z = a.x == 0;
            o = sign(a.x);
            p = sign(a.d);
            r = sign(a.dd);
%             ds = a.d .* ones(size(a.d)); ds(z) = NaN;
%             dds = a.dd.*ones(size(a.dd);
            obj = Dual(o,p,r);
        end
%         function obj = pow2(a)
%             obj = Dual(pow2(a.x), a.d .* log(2) .* pow2(a.x));
%         end
%         function obj = erf(a)
%             disp('Reached here')
%             ds = 2/sqrt(pi) * exp(-(a.x).^2);
%             obj = Dual(erf(a.x), a.d .* ds);
%         end
%         function obj = erfc(a)
%             disp('Reached here')
%             ds = -2/sqrt(pi) * exp(-(a.x).^2);
%             obj = Dual(erfc(a.x), a.d .* ds);
%         end
%         function obj = erfcx(a)
%             ds = 2 * a.x .* exp((a.x).^2) .* erfc(a.x) - 2/sqrt(pi);
%             obj = Dual(erfcx(a.x), a.d .* ds);
%         end
        % Exponential and logarithm
        function obj = exp(a)
            obj = Dual(exp(a.x), a.d .* exp(a.x), a.dd.*exp(a.x)+a.d.*a.d.*exp(a.x));
        end
        function obj = log(a)
            obj = Dual(log(a.x), a.d ./ a.x, a.dd./a.x - a.d.*a.d./(a.x.*a.x));
        end
        % Trigonometric functions
        function obj = sin(a)
            obj = Dual(sin(a.x), a.d .* cos(a.x), a.dd.*cos(a.x)-a.d.*a.d.*sin(a.x));
         %   obj = Dual(sin(a.x), a.d .* cos(a.x),-a.d.*a.d.*sin(a.x));
        end
        function obj = cos(a)
            obj = Dual(cos(a.x), -a.d .* sin(a.x), -a.dd.*sin(a.x)-a.d.*a.d.*cos(a.x));
        %    obj = Dual(cos(a.x), -a.d .* sin(a.x), -a.d.*a.d.*cos(a.x));
        end
        function obj = tan(a)
            obj = Dual(tan(a.x), a.d .* sec(a.x).^2, 2*a.d.*sec(a.x).^2.*tan(a.x).*a.d + a.dd.*sec(a.x).^2);
        end
        
 % do not forget to add dd parts        
         function obj = asin(a)
             dpdas    = a.d.*a.d.*a.x./(1-a.x.^2).^(3/2);
             obj      = Dual(asin(a.x), a.d ./ sqrt(1-(a.x).^2),dpdas);
         end
         function obj = acos(a)
             dpdac    = -a.d.*a.d.*a.x./(1-a.x.^2).^(3/2);
             obj      = Dual(acos(a.x), -a.d ./ sqrt(1-(a.x).^2),dpdac);
        end
        function obj = atan(a)
            dpdat = -2*a.d.*a.d.*a.x./(a.x.^2+1).^2;
            obj   = Dual(atan(a.x), a.d./ (1 + (a.x).^2),dpdat);
            
        end
        % Hyperbolic trig functions
        function obj = sinh(a)
            obj = Dual(sinh(a.x), a.d .* cosh(a.x), a.d.*a.d.*sinh(a.x));
        end
        function obj = cosh(a)
            obj = Dual(cosh(a.x), a.d .* sinh(a.x), a.d.*a.d.*cosh(a.x));
        end
        function obj = tanh(a)
            tapdd = 2*a.d.*a.d.*tanh(a.x).*(tanh(a.x).^2-1);
            obj = Dual(tanh(a.x), a.d .*(1-tanh(a.x).^2) , tapdd );
        end
        function obj = asinh(a)
            pasinh   = -a.x.*a.d.*a.d./((a.x).^2 + 1).^(3/2);
            obj      = Dual(asinh(a.x), a.d./ sqrt((a.x).^2 + 1),pasinh);
        end
        function obj = acosh(a)
            pacosh   = -a.x.*a.d.*a.d./((a.x).^2 - 1).^(3/2);
            obj      = Dual(acosh(a.x), a.d./ sqrt((a.x).^2 - 1),pacosh);
        end
        function obj = atanh(a) 
                 patanh = 2*a.x.*a.d.*a.d./((a.x).^2 - 1).^2;
                 obj = Dual(atanh(a.x), a.d./ (1 - (a.x).^2),patanh);
        end 
        
%         function disp(obj)
%             if obj.d==0
%                 disp(obj.f);
%             elseif obj.d==1
%                 fprintf("%s\n", num2str(obj.f) +" + e");
%             elseif obj.df>0
%                 fprintf("%s\n", num2str(obj.f) +" + " +num2str(obj.df) + "e");
%             elseif obj.df==-1
%                 fprintf("%s\n", num2str(obj.f) +" - e");
%             else
%                 fprintf("%s\n", num2str(obj.f) +" - " +num2str(abs(obj.df)) + "e");
%             end            
%         end
        
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

