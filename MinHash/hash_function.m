function hc = hash_function(elemento,hf,R,p)
    % USAGE = hash_function('Toy',3,randI(127,100,3),127)
    codigos_ASCII = double(elemento);
    r = R(hf,:);
    %p = 127;

    hc = mod(codigos_ASCII * r', p);
end