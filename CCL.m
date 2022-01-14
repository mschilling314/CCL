function [label_img,num] = CCL(img)
%CCL Determines the number of regions and colors them.
%   Utlilizes traditional CCL algorithms.
%imorig = imread(img);
imorig = img;
[m, n] = size(imorig);
label_img = zeros(m,n);
num = 0;
eqtab = {};

%this is the first loop for finding the regions
%and creating the equivalence table
for a = 1:m
    for b = 1:n
        %fprintf('a = %lu, b = %lu, pixel = %lu, ', a, b, imorig(a,b));
        if imorig(a,b) == 1
            %first set labels up for upper and left
            if a == 1
                Lu = 0;
            else
                Lu = label_img(a-1,b);
            end
            if b == 1
                Ll = 0;
            else
                Ll = label_img(a,b-1);
            end
            %fprintf('Lu = %lu, Ll = %lu, ', Lu, Ll);
            
            
            
            %next do algo to label current pixel
            if Lu == 0
                if Ll == 0
                    %implies this is a new region
                    num = num + 1;
                    label_img(a,b) = num;
                    %adding to eq table to allow for easier greyscale gen
                    eqtab = {eqtab, num};
                    eqtab = horzcat(eqtab{:});
                else
                    %implies this is connected to left p not upper
                    label_img(a,b) = Ll;
                end
            else
                if Ll == 0
                    %implies this is connected to upper not left
                    label_img(a,b) = Lu;
                else
                    %LARGE PART
                    %implies connection to upper and left
                    label_img(a,b) = min(Ll, Lu);
                    %tests to see if this equivalence is a box
                    if Ll ~= Lu
                        %implement equivalence table here
                        LlI = 0;
                        LuI = 0;
                        %figure out if either label is already in a set
                        for t = 1:size(eqtab,2)
                            if memhuh(Ll,eqtab{1,t})
                                LlI = t;
                            end
                            if memhuh(Lu,eqtab{1,t})
                                LuI = t;
                            end
                        end
                        %if the labels are already in the same set do nada
                        if LlI ~= 0 && LlI == LuI
                        %if neither label is in a set, create set
                        elseif LlI == 0 && LuI == 0
                            eqtab = {eqtab, [Ll, Lu]};
                            eqtab = horzcat(eqtab{:});
                        %if one but not the other is in a set, add to set
                        elseif LlI == 0
                                %Ll is not in a set, so add it to Lu's
                                eqtab{1,LuI} = [eqtab{1,LuI}, Ll];
                    elseif LuI == 0
                                %Lu is not in a set, so add it to Ll's
                                eqtab{1,LlI} = [eqtab{1,LlI}, Lu];
                        %if both in set, union sets
                        else
                            eqtab = munion(eqtab,LlI,LuI);
                        end
                    end
                end
            end
        end
        %fprintf('num = %lu \n', num);
    end
end

num = size(eqtab,2);
x = linspace(0,255,num+1);

%now, we have to go back through and re-assign regions based on the 
%equivalence table, as well as draw the greyscale
for a = 1:m
    for b = 1:n
        %only want to actually stop to check for eq if in fact pixel is 1
        if label_img(a,b) ~= 0
            %now, iterate through eq table to check for eq & reassign
            %t is basically the set index, which is linearly mapped to give
            %proper greyscale values
            for t = 1:size(eqtab,2)
                if memhuh(label_img(a,b), eqtab{1,t})
                    label_img(a,b) = x(t+1);
                end
            end
        end
    end
end



end

