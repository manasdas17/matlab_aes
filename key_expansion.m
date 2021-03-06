function w = key_expansion (key, s_box, rcon, round_num)
    switch round_num
        case 10
            Nk = 4 ;
        case 12
            Nk = 6 ;
        case 14
            Nk = 8 ;
        otherwise
            error('incorrect round number') ;
    end
    w = (reshape (key, 4, Nk))';
    % every round need 16 bytes, so 
    % 128 bit is 5:44
    % 256 bit is 5:60.  60*4 = (14+1)*16
    for i = (Nk+1) : (round_num+1)*4
        temp = w(i - 1, :);    %get data of all line in array
        temp_t = dec2hex(temp) 
        if mod (i, Nk) == 1
            temp = rot_word (temp);
            temp = sub_bytes (temp, s_box);
            r = rcon ((i - 1)/Nk, :);
            temp = bitxor (temp, r);
        elseif mod (i, 4) == 1
            temp = sub_bytes (temp, s_box);       
            temp_t = dec2hex(temp) ;
        end
        w(i, :) = bitxor (w(i - Nk, :), temp);       %join array
    end
