function  salida = func_activ(act, dato,ciclo)
    if ciclo==2;
    for count=1:25;
    salida(count,1)=1/(1+exp(-act*dato(count)));
    end
    elseif ciclo==3;
    for count=1:10;
    salida(count,1)=1/(1+exp(-act*dato(count)));
    end
    end
end