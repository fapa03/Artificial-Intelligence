close all; clear all; %clc;
rng('default');
%% Configuracion de parametros
entradas = 20*20;%resolucion de las imagenes
capadesalida = 10;
Neuronas = [entradas, 25, capadesalida];
L=numel(Neuronas); % Capas incluyendo la entrada y salida(Layers)
n=1; % Inicializaci´on del primer instante
%num_muestras = 60000; % N´umero de muestras de entrenamiento
num_muestras = 60000; % N´umero de muestras de entrenamiento
eta=0.005; % Factor de aprendizaje
alpha=1; % Factor de olvido
a = 1; % Factor para funci´on de activaci´on
bias = 0.001;
%% Inicializacion de las entradas
load('DigitosProcesados.mat'); d = YTrain;
%% Damos pesos iniciales


epsilon_init=0.12;
for l=2:L
    w{l} = [rand(Neuronas(l), Neuronas(l-1))]*2*epsilon_init-epsilon_init;
end
tic
%algoritmo(Neuronas,L,n,num_muestras,eta,alpha,a,bias);
%% Comienza el algoritmo
e{1,1}=1;
 for yy=1:200 %Probamos con 200 epocas
    orden = randperm(num_muestras);
%% =============== Inicia el corrido hacia adelante
    for i=1:num_muestras
        n = orden(i);
        ye{1} = XTrain(:, n);
        for l=2:L
            temp1=w{l}; temp2=ye{l-1};
            v{l} = temp1*temp2+bias*ones(Neuronas(l), 1);
            ye{l} = func_activ(a, v{l},l);
        end
        e{:, i} = d(:, n)-ye{L};
%% ==========  Inicia la retropropagacion
        for l=L:-1:1
            if l==L
                delta{l}=a*ye{l}.*(1.-ye{l}).*e{:,i};
            else
                delta{l} = a*ye{l}.*(1.-ye{l}).*(w{l+1}'*delta{l+1});
            end
        end
%% ============= Se retroalimentan los pesos
        for l=2:L
            deltaw{l,i}=eta*delta{l}*ye{l-1}';
            if(i>1)
                w{l} = w{l} + alpha*(deltaw{l,i-1})+deltaw{l,i};
            else
                w{l} = w{l}+deltaw{l,i};
            end
        end
    end
    norm([e{:,:}])
    disp('Epoca')
    disp(yy)
 end

%% Test de la configuracion obtenida
num_pruebas = 10000;
% figure;
% displayData(XTest(:, 1:12)');
dt = YTest;
%% Test de prueba
for n=1:num_pruebas
    yfinal{1} = XTest(:,n);
    for l=2:L
        vfinal{l,n} = w{l}*yfinal{l-1}+bias*ones(Neuronas(l), 1);
        yfinal{l} = func_activ(a, vfinal{l,n},l);
    end
    %% Calculo del error y salida final
    yn{n} = yfinal{L};
    dfinal{n} = round(yn{n});
    
    
end
%% Comprobacion de Salidas obtenidas contra esperadas
cont = 0;
for i=1:num_pruebas
    if(dfinal{i} == dt(:, i))
        r = ['Digito ', num2str(i), ' Bien'];
        cont = cont+1;
        
         q = round(4999*rand + 1);      
        % imshow(vec2mat(XTest(:,q),20)','InitialMagnification',300)
        
    else
        r = ['Digito ', num2str(i), ' Mal'];
        %disp(r);

    end
end
r = ['Muestras correctas: ', num2str(cont)];
disp(r);
         q = round(4999*rand + 1);      
         imshow(vec2mat(XTest(:,q),20)','InitialMagnification',300)
toc


