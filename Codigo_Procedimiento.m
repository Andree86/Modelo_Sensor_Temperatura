% -------------------------- Parametros ---------------------------
% name = 'Sens';     % Ruta de la variable que guarda los datos
valores     = table2array(Prueba2final);
temp_inicio = 32.2;                        % Temperatura de inicio para el analisis 

% ---------------------- Digitalizar valores ----------------------
% valores = out.name.signals.values;
t = valores(:,1);
sensor1_aux = valores(:,2);
sensor2_aux = valores(:,3);
sensor3_aux = valores(:,4);

% ------------------------- Procedimiento -------------------------
% Corrección de retraso
band = true;
band1 = false;
band2 = false;
band3 = false;
i = 1;
while band
    if sensor1_aux(i) > temp_inicio && band1 == false
        i1_aux = i - 1;
        band1 = true;
    end
    if sensor2_aux(i) > temp_inicio && band2 == false
        i2_aux = i - 1;
        band2 = true;
    end
    if sensor3_aux(i) > temp_inicio && band3 == false
        i3_aux = i - 1;
        band3 = true;
    end
    if band1 && band2 && band3
        band = false;
    end
    i = i+1;
end
row = size(valores,1);

% Gurdar los datos corregidos 
sensor1 = sensor1_aux(i1_aux:row,1);
sensor2 = sensor2_aux(i2_aux:row,1);
sensor3 = sensor3_aux(i3_aux:row,1);

% Se detecta las filas de los datos
sensor1_row = size(sensor1,1);
sensor2_row = size(sensor2,1);
sensor3_row = size(sensor3,1);

% Se crea el tiempo de simulación de cada sensor
sensor1_t = (1:sensor1_row)';
sensor2_t = (1:sensor2_row)';
sensor3_t = (1:sensor3_row)';

% Valores en variables de desviación
sensor1 = sensor1(:,1)-sensor1(1,1);
sensor2 = sensor2(:,1)-sensor2(1,1);
sensor3 = sensor3(:,1)-sensor3(1,1);

% Ganancia
delta_u = 1 - 0;
K1 = sensor1(end,1)/delta_u; % Ganancia para el sensor 1
K2 = sensor2(end,1)/delta_u; % Ganancia para el sensor 2
K3 = sensor3(end,1)/delta_u; % Ganancia para el sensor 3

% Tau
fun1_aux = @(tau,t) K1*delta_u*(1-exp(-sensor1_t/tau)); % Definimos la función para el sensor 1
fun2_aux = @(tau,t) K2*delta_u*(1-exp(-sensor2_t/tau)); % Definimos la función para el sensor 2
fun3_aux = @(tau,t) K3*delta_u*(1-exp(-sensor3_t/tau)); % Definimos la función para el sensor 3

tau1 = round(nlinfit(sensor1_t,sensor1,fun1_aux,1)); % Minimizamos la suma del error al cuadrado del sensor 1
tau2 = round(nlinfit(sensor2_t,sensor2,fun2_aux,1)); % Minimizamos la suma del error al cuadrado del sensor 2
tau3 = round(nlinfit(sensor3_t,sensor3,fun3_aux,1)); % Minimizamos la suma del error al cuadrado del sensor 3

% Función que describe el sistema
fun1 = K1*delta_u*(1-exp(-sensor1_t/tau1)); % Del sensor 1
fun2 = K2*delta_u*(1-exp(-sensor2_t/tau2)); % Del sensor 2
fun3 = K3*delta_u*(1-exp(-sensor3_t/tau3)); % Del sensor 3

% ------------------- Función de Transferencia --------------------
% Definir numerador y denominador de las ft's
tf1_num = [K1];
tf1_den = [tau1 1];
tf2_num = [K2];
tf2_den = [tau2 1];
tf3_num = [K3];
tf3_den = [tau3 1];

% Creación de las ft's
tf1 = tf(tf1_num,tf1_den);
tf2 = tf(tf2_num,tf2_den);
tf3 = tf(tf3_num,tf3_den);

% --------------------------- Graficas ----------------------------
close all;
% Parametros generales
gris = [0.4 0.4 0.4 0.5];
temp_tau1 = sensor1(tau1,1);
temp_tau2 = sensor2(tau2,1);
temp_tau3 = sensor3(tau3,1);

% ----- Posicionar Grafica ------
% Dimensiones de la pantalla
tamano_pan = get(0, 'ScreenSize'); 
ancho_pan = tamano_pan(3); % Ancho de la pantalla
alto_pan = tamano_pan(4);  % Altura de la pantalla

% Tamaño de cada Ventana
ancho_fig = ancho_pan / 2;
alto_fig = alto_pan / 2;

% ---------- Grafica 1 ----------
f1 = figure;
hold on;
grid on;

% Grfica
plot(sensor1_t,sensor1,'r',sensor1_t,fun1,'--b','LineWidth',2);
title('Lectura del sensor 1');
ylabel('Temperatura (°C)');
xlabel('Tiempo');

% Linea rectas en x 
yline(sensor1(end,1),'--','Color',gris,'LineWidth',2);
plot ([0 tau1],[temp_tau1 temp_tau1],'--','Color',gris,'LineWidth',2);

% Linea recta en y
plot ([tau1 tau1],[0 temp_tau1],'--','Color',gris,'LineWidth',2);

% Texto de la grafica
text(50,(sensor1(end,1) + 0.8),'Estabilización','Color',gris)
text((tau1 + 50),temp_tau1,'Tau','Color',gris);

% Punto 
plot(tau1,temp_tau1,'ko','MarkerFaceColor', 'k','MarkerSize', 8);

% Dimensiones
xlim([0 sensor1_t(end,1)]);
ylim([0 (sensor1(end,1) + 5)]);

% Mostrar Grafica
set(f1,'Position',[0 (alto_fig + 1) ancho_fig (alto_fig - 82)]);
saveas(gcf, 'Latex/Imagenes/Grafica1.png')

% ---------- Grafica 2 ----------
f2 = figure;
hold on;
grid on;

% Grfica
plot(sensor2_t,sensor2,'g',sensor2_t,fun2,'--b','LineWidth',2);
title('Lectura del sensor 2');
ylabel('Temperatura (°C)');
xlabel('Tiempo');

% Linea rectas en x 
yline(sensor2(end,1),'--','Color',gris,'LineWidth',2);
plot ([0 tau2],[temp_tau2 temp_tau2],'--','Color',gris,'LineWidth',2);

% Linea recta en y
plot ([tau2 tau2],[0 temp_tau2],'--','Color',gris,'LineWidth',2);

% Texto de la grafica
text(50,(sensor2(end,1) + 0.8),'Estabilización','Color',gris)
text((tau2 + 50),temp_tau2,'Tau','Color',gris);

% Punto 
plot(tau2,temp_tau2,'ko','MarkerFaceColor', 'k','MarkerSize', 8);

% Dimensiones
xlim([0 sensor2_t(end,1)]);
ylim([0 (sensor2(end,1) + 5)]);

% Mostrar Grafica
set(f2,'Position',[(ancho_fig + 1) (alto_fig +1) ancho_fig (alto_fig - 82)]);
saveas(gcf, 'Latex/Imagenes/Grafica2.png')

% ---------- Grafica 3 ----------
f3 = figure;
hold on;
grid on;

% Grfica
plot (sensor3_t,sensor3,'m',sensor3_t,fun3,'--b','LineWidth',2);
title ('Lectura del sensor 3');
ylabel ('Temperatura (°C)');
xlabel('Tiempo');

% Linea rectas en x 
yline (sensor3(end,1),'--','Color',gris,'LineWidth',2);
plot ([0 tau3],[temp_tau3 temp_tau3],'--','Color',gris,'LineWidth',2);

% Linea recta en y
plot ([tau3 tau3],[0 temp_tau3],'--','Color',gris,'LineWidth',2);

% Texto de la grafica
text (50,(sensor3(end,1) + 0.8),'Estabilización','Color',gris)
text ((tau3 + 50),temp_tau3,'Tau','Color',gris);

% Punto 
plot (tau3,temp_tau3,'ko','MarkerFaceColor', 'k','MarkerSize', 8);

% Dimensiones
xlim([0 sensor3_t(end,1)]);
ylim([0 (sensor3(end,1) + 5)]);

% Mostrar Grafica
set(f3,'Position',[0 0 ancho_fig (alto_fig - 82)]);
saveas(gcf, 'Latex/Imagenes/Grafica3.png')

% ---------- Grafica 4 ----------
f4 = figure;
hold on;
grid on;

plot (sensor1_t,sensor1,'r',sensor2_t,sensor2,'g',sensor3_t,sensor3,'m','LineWidth',2);
title('Comparación de los sensores');
xlabel('Tiempo');
ylabel('Temperatura (°C)');

% Dimensiones
xlim([0 t(end,1)]);
ylim([0 (sensor1(end,1) + 5)]);

% Mostrar Grafica
set(f4,'Position',[(ancho_fig + 1) 0 ancho_fig (alto_fig - 82)]);
saveas(gcf, 'Latex/Imagenes/Grafica4.png')