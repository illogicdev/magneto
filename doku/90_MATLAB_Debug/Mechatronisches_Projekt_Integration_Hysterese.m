% Mechatronisches Projekt - Integrationsverfahren
% 1) Messung in LabView starten (nicht als exe-Datei!)
% 2) Nach Messende Rechtsklick auf Diagramm -> Daten exportieren -> in Zwischenablage
% 3) Daten in Excel einfuegen und als CSV-Datei exportieren (am Besten H und B getrennt)
% 4) Ggfs. CSV-Dateien mit Notepad++ nachbearbeiten (STRG+F -> Replace)
% 5) Dezimalzahl bearbeiten, sodass diese einen Dezimalpunkt enthaellt "."
% 6) Am Zeilenende muss ein Komma eingefuegt werden (Replace "\r" mit ",")
% 7) Pfad zu den CSV-Dateien hier im Skript abaendern


% Probedaten
frequenz = 50; %[Hz]
dichte = 7.84; %[g/cm^3]


% Imort der csv Dateien f�r H und B Arra
% Pfad eventuell anpassen, Daten muessen Kommagetrennt sein und einen Dezimalpunkt enthalten
path_b_csv = 'C:\Users\Jan Philipp\Documents\zz_Mechatronisches_Projekt\doku\80_Beispielmessdaten\50Hz - 1.5T\B.csv';
path_h_csv = 'C:\Users\Jan Philipp\Documents\zz_Mechatronisches_Projekt\doku\80_Beispielmessdaten\50Hz - 1.5T\H.csv';

% Einlesen der CSV-Dateien
b_array_in = csvread(path_b_csv);
b_array = transpose(b_array_in(:,1));
h_array_in = csvread(path_h_csv);
h_array = transpose(h_array_in(:,1));

messpunkte = length(b_array)
hys_verluste = 0;

% Integration
for a = 1:(messpunkte -1)
    hys_verluste = hys_verluste + (h_array(a) - h_array(a+1)) * ((b_array(a) + b_array(a+1))/2);
end

hys_verluste = (hys_verluste * frequenz)/(dichte * 1000)