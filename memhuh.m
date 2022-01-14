function tralse = memhuh(el,mset)
%memhuh Checks for membership in mathematical set
%   el is the potential element, mset is an array
tralse = 0;
for t = 1:size(mset,2)
    %iterate through the set, represented as an array, checking els
    if el == mset(t)
        tralse = 1;
    end
end
end

