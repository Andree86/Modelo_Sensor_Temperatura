% Definición de matrices del sistema
A = [-(1/278), 0, 0;
     (0.7933/286), -(1/286), 0;
     0, (0.8645/292), -(1/292)];
B = [(16.94/278); 0; 0];
C = [1, 0, 0;
     0, 1, 0;
     0, 0, 1];
D = 0;

% Crear el sistema en espacio de estados
sys = ss(A, B, C, D);

% Definir el vector de tiempo
t = 0:1:1500;

% Respuesta al escalón
[y, t_out] = step(sys, t);

% Tamaño de pantalla
tamano_pan = get(0, 'ScreenSize'); 
ancho_pan = tamano_pan(3); % Ancho de la pantalla
alto_pan = tamano_pan(4);  % Altura de la pantalla

% Tamaño de cada Ventana
ancho_fig = ancho_pan / 5;
alto_fig = alto_pan / 4;

% Graficar salidas
fig = figure;
hold on;
plot(t_out, y(:,1), 'r',t_out, y(:,2), 'g',t_out, y(:,3),'b','LineWidth', 1.5);
hold off;

title('Respuesta al escalón del sistema');
xlabel('Tiempo (s)');
ylabel('Temperatura');
legend('X1', 'X2', 'X3');
grid on;

set(fig,'Position',[ancho_fig alto_fig ancho_fig*3 alto_fig*2]);
saveas(gcf, 'Latex/Imagenes/Grafica5.png')

