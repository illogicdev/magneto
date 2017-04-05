Unit ANFANG;

Interface

Uses CRT,VARDEF,IEEEPAS;

{
**************************************************************************
}
Procedure BEGRUESS;
Procedure EINGABE0;
Procedure EINGABE1;
Procedure EINGABE2;
{
**************************************************************************
**************************************************************************
}

Implementation

Procedure BEGRUESS;
{***********************************
erst.: am 22.11.94 von M.Schweizer
ge„n.: 15.01.99 von U. Weidlich
       neue Bezeichnungen fr Hochschule und Labor

BEGRUESS:
Gibt einen kurzen šberblick ber die Funktionen des Programmes.
***********************************}
var
   antwort : char;
   j       : char;    { Antwortvariable }
   n       : char;    { Antwortvariable }

begin
  textbackground (black);
  clrscr;
  textbackground (green);
  textcolor (black);
  window (6,2,78,24);
  gotoxy (1,1);
  writeln ('                                                                     ');
  writeln ('                            Hochschule Esslingen                     ');
  writeln ('                                                                     ');
  writeln ('           Labor Elektrotechnik - Elektrische Werkstoffprfung       ');
  writeln ('                                                                     ');
  gotoxy (1,7);
  writeln ('                                                                     ');
  writeln ('             Programm zur Messung magnetischer Gr”áen                ');
  writeln ('                                                                     ');
  writeln ('                Folgende Gr”áen werden berechnet !                   ');
  writeln ('                                                                     ');
  gotoxy (1,13);
  writeln ('                                                                     ');
  writeln ('               - Die Hystereseschleife                               ');
  writeln ('               - Die Kommutierungskurve                              ');
  writeln ('               - Br ( Remanenz )                                     ');
  writeln ('               - Hc ( Koerzitivfeldst„rke )                          ');
  writeln ('               - Bmax und Hmax                                       ');
  writeln ('               - Der Permeabilit„tsverlauf                           ');
  writeln ('               - Die Ummagnetisierungsverluste P                     ');
  writeln ('                                                                     ');
  textbackground (cyan);
  gotoxy (1,22);
  writeln ('   Information zum Meáaufbau ?                                       ');
  textcolor (blink);
  gotoxy (60,22);
  write ('(J / N)');
  sound (1250);
  delay (250);
  nosound;

  repeat

  antwort:=readkey

  until antwort in ['J','j','N','n'];

  if antwort in ['J','j'] then

  begin
    textbackground (green);
    textcolor (black);
    clrscr;
    window (6,2,78,24);
    { Beschreibung des Meáaufbaus + Liste der Ger„te }
    writeln('                                                                     ');
    writeln(' Folgende Ger„te sind zur Messung notwendig.                         ');
    writeln('                                                                     ');
    writeln('                                                                     ');
    writeln(' PC mit IEEE-488 Schnittstellenkarte (Keithley KPC-488)                             ');
    writeln('                                                                     ');
    writeln(' Hewlett Packard 54600 A Oszilloskop (IEEE-Adresse 7)                ');
    writeln('                                                                     ');
    writeln(' Hewlett Packard Pulse/Function Generator 8116A (IEEE-Adresse 16)    ');
    writeln('                                                                     ');
    writeln('                                                                     ');
    writeln(' Der PC, das Oszilloskop und der Frequenzgenerator sind mit          ');
    writeln(' IEEE Bus Kabeln zu verbinden.                                       ');
    writeln('                                                                     ');
    textcolor (blink);
    writeln(' weiter mit J                                                        ');
    writeln('                                                                     ');

    repeat

    antwort:=readkey

    until antwort in ['J','j'];

    begin
      clrscr;
      window (6,2,78,24);
      textcolor (black);
      writeln('                                                                   ');
      writeln(' Meáaufbau:                                                        ');
      writeln('                                                                   ');
      writeln(' Die Meáger„te sind an den Meábuchsen wie folgt zu verbinden       ');
      writeln('                                                                   ');
      writeln(' Epsteinrahmenkabel ist Ausgangspunkt.                             ');
      writeln('                                                                   ');
      writeln(' bl dick Kabel ist mit dem Signal Ausg. des Freq.gen. zu verbinden ');
      writeln(' sw dick Kabel ist mit dem CH2 Signal Eing. des Oszi''s zu verbinden');
      writeln(' br dnn Kabel ist mit dem CH1 Signal Eing. des Oszi''s zu verbinden');
      writeln(' ws dnn Kabel ist mit dem CH1 Ground des Oszi''s zu verbinden      ');
      writeln('                                                                   ');
      writeln(' Die Grounds von Freq.gen. und CH2 des Oszi''s sind zu verbinden.   ');
      writeln('                                                                   ');
      writeln(' Der SHUNT ist zwischen CH2 Signal Eing. und CH2 Ground des Oszi''s ');
      writeln(' anzuschlieáen.                                                    ');
      writeln('                                                                   ');
      textcolor (red);
      writeln(' Achtung beim Meáaufbau !!! Kurzschluágefahr bei falschem Aufbau !!');
      textcolor (red+blink);
      writeln(' Achtung beim Meáaufbau !!! Kurzschluágefahr bei falschem Aufbau !!');
      textcolor (red);
      writeln(' Achtung beim Meáaufbau !!! Kurzschluágefahr bei falschem Aufbau !!');
      writeln('                                                                     ');
      textcolor (blink);
      writeln(' weiter mit J                                                      ');
      writeln('                                                                   ');
      textcolor (white);
      textbackground (black);
    end;

    repeat

    antwort:=readkey

    until antwort in ['J','j'];

  end;

  if antwort in ['N','n'] then

  begin
    textbackground (black);
    textcolor (white);
    clrscr;
  end;

end; { ENDE BEGRUESS }
{
**************************************************************************
}
Procedure EINGABE0;
{***********************************
erst.: am 22.11.94 von M.Schweizer
ge„n.: am
was  :
EINGABE0:
Hier wird folgender Wert eingelesen :
   messnr   : integer     Laufende Messnummer eingeben.
***********************************}
var
   antwort2 : char;
   antwort1 : longint;
   str      : string[20];
   code     : integer;

begin

  repeat

  window (1,1,78,24);
  clrscr;

  repeat

  repeat

  textbackground (green);
  textcolor (black);
  window (6,2,78,24);
  gotoxy (1,1);
  writeln ('                                                                     ');
  writeln ('          Bitte geben Sie die gewnschte Messnummer ein :            ');
  writeln ('          (     Wertebereich Messnummer : 1....1000     )            ');
  writeln ('                                                                     ');
  readln (str);
  delete (str,13,255);
  val (str,antwort1,code);
  messnr:=antwort1;
  gotoxy (1,5);
  textbackground (black);
  writeln ('                                                                     ');

  until messnr >= 1;

  until messnr <= 1000;

  textbackground (green);
  gotoxy (1,2);
  writeln ('                                                                     ');
  writeln ('                       gewnschte Messnummer :                       ');
  writeln ('                                                                     ');
  writeln ('                                                                     ');
  gotoxy (51,3);
  write (messnr);

  textbackground (cyan);
  gotoxy(1,6);
  writeln ('       Ist die Messnummer richtig ?                                  ');
  textcolor (blink);
  gotoxy (60,6);
  write ('(J / N)');
  textbackground (black);
  sound (1250);
  delay (250);
  nosound;

  repeat

  antwort2:=readkey

  until antwort2 in ['J','j','N','n'];

  until antwort2 in ['J','j'];

  textbackground (black);
  textcolor (white);
end; { ENDE EINGABE0 }
{
**************************************************************************
}
Procedure EINGABE1;
{***********************************
erst.: am 22.11.94 von M.Schweizer

ge„n.: am 21.02.95 von U. Weidlich
       Text korrigiert, IEEE-Adressen werden angezeigt
       2 Nachkommastellen fr Dichte werden angezeigt

       am 20.02.98 von U. Weidlich
       Text berarbeitet
       1 Nachkommastelle fr Querschnittsfl„che wird angezeigt

       am 15.01.99 von U. Weidlich
       Stringl„nge fr Probenbezeichnung auf 15 Zeichen verl„ngert

       Wertebereich fr Shunt ab 0,1 Ohm, d.h. auch eine Nachkommastelle
       wird angezeigt

       alle Zahlenwerte k”nnen auch mit Komma statt Dezimalpunkt eingegeben
       werden

       zweite REPEAT-Schleife bei den Eingaben entfernt; alle Bedingungen werden
       in einer UNTIL-Anweisung geprft. Zus„tzliche šberprfung, ob die
       Umwandlung in einen numerischen Wert erfolgreich war



EINGABE1:
Hier werden folgende Werte eingelesen oder berechnet:
   text_pr    : string;       Ein_par : Textbezeichnung
   lm         : single;       Ein_par : Mittlere L„nge
   a          : single;       Ein_par : Querschnitt des Eisens
   dichte     : single;       Ein_par : Dichte des Materials
   n1         : single;       Ein_par : Prim„rwindungszahl
   n2         : single;       Ein_par : Sekund„rwindungszahl
   spgteiler  : single;       Ein_par : Spannungsteiler
   n2theo     : single;       Ber_par : Theo Sekund„rwindungszahl
   shunt      : single;       Ein_par : Meáwiderstand
   faktor1    : double;       Ber_par : Umwandlung der Meáspannung in Fluádichte
   faktor2    : double;       Ber_par : Umwandlung der Meáspannung in Feldst„rke
***********************************}
var
   antwort1 : single;
   antwort2 : char;
   str      : string[10];
   code     : integer;

begin
  window (1,1,78,24);
  clrscr;

  repeat

  textbackground (black);
  textcolor (black);
  clrscr;
  textbackground (green);
  window (6,2,78,24);
  gotoxy (1,1);
  writeln ('                                                                     ');
  gotoxy (1,2);
  writeln (' Bitte geben Sie die Bezeichnung der Probe ein : ( max 15 Zeichen )  ');
  writeln ('                                                                     ');
  readln (text_pr);
  delete (text_pr,16,255);
  gotoxy (1,2);
  writeln ('                             Probenbezeichnung :                     ');
  gotoxy (52,2);
  write (text_pr);
  gotoxy (70,4);
  textbackground (black);
  write ('    ');
  textbackground (green);

  repeat

  gotoxy (1,4);
  writeln ('     Bitte geben Sie die wirksame L„nge lm in cm ein :               ');
  writeln ('     (   Wertebereich der wirksamen L„nge : 1....1000 cm   )         ');
  readln (str);
  gotoxy (1,6);
  textbackground (black);
  write ('                                                                          ');
  gotoxy (1,7);
  write ('                                                                          ');
  textbackground (green);
  delete (str,13,255);
  if (Length(str) > 0) AND (Pos(',', str) > 0) then str[Pos(',', str)]:='.';
  val (str,antwort1,code);
  lm:=antwort1;

  until (lm >= 1) AND (lm <= 1000) AND (code = 0);

  gotoxy (1,4);
  writeln ('                                wirksame L„nge :                 ');
  writeln ('                                                                     ');
  gotoxy (50,4);
  write (lm:8:1);
  write (' [cm]');

  repeat

  gotoxy (1,6);
  writeln ('     Bitte geben Sie den Eisenquerschnitt A in mm^2 ein :            ');
  writeln ('     (  Wertebereich des Eisenquerschnittes : 1....10000 mm^2  )     ');
  readln (str);
  gotoxy (1,8);
  textbackground (black);
  write ('                                                                         ');
  gotoxy (1,9);
  write ('                                                                         ');
  textbackground (green);
  delete (str,13,255);
  if (Length(str) > 0) AND (Pos(',', str) > 0) then str[Pos(',', str)]:='.';
  val (str,antwort1,code);
  a:=antwort1;

  until (a >= 1) AND (a <= 10000) AND (code = 0);

  gotoxy (1,6);
  writeln ('                              Eisenquerschnitt :                 ');
  writeln ('                                                                     ');
  gotoxy (50,6);
  write (a:9:1);
  write (' [mm^2]');

  repeat

  gotoxy (1,8);
  writeln ('     Bitte geben Sie die Dichte des Eisen in g/cm^3 ein :            ');
  writeln ('     (   Wertebereich der Eisendichte : 1....50 g/cm^3   )           ');
  readln (str);
  gotoxy (1,10);
  textbackground (black);
  write ('                                                                         ');
  gotoxy (1,11);
  write ('                                                                         ');
  textbackground (green);
  delete (str,13,255);
  if (Length(str) > 0) AND (Pos(',', str) > 0) then str[Pos(',', str)]:='.';
  val (str,antwort1,code);
  dichte:=antwort1;

  until (dichte >= 1) AND (dichte <= 50) AND (code = 0);

  gotoxy (1,8);
  writeln ('                             Dichte des Eisens :                 ');
  writeln ('                                                                     ');
  gotoxy (49,8);
  write (dichte:5:2);
  write (' [g/cm^3]');

  repeat

  gotoxy (1,10);
  writeln ('     Bitte geben Sie die Prim„rwindungszahl ein :                    ');
  writeln ('     (   Wertebereich der Prim„rwindungszahl 1...1500   )            ');
  readln (str);
  gotoxy (1,12);
  textbackground (black);
  write ('                                                                         ');
  gotoxy (1,13);
  write ('                                                                         ');
  textbackground (green);
  delete (str,13,255);
  if (Length(str) > 0) AND (Pos(',', str) > 0) then str[Pos(',', str)]:='.';
  val (str,antwort1,code);
  n1:=antwort1;

  until (n1 >= 1) AND (n1 <= 1500) AND (code = 0);

  gotoxy (1,10);
  writeln ('                            Prim„rwindungszahl :                 ');
  writeln ('                                                                     ');
  gotoxy (49,10);
  write (n1:7:0);
  write (' Windungen');

  repeat

  gotoxy (1,12);
  writeln ('     Bitte geben Sie die Sekund„rwindungszahl ein :                  ');
  writeln ('     (   Wertebereich der Sekund„rwindungszahl 1...1500   )          ');
  readln (str);
  gotoxy (1,14);
  textbackground (black);
  write ('                                                                         ');
  gotoxy (1,15);
  write ('                                                                         ');
  textbackground (green);
  delete (str,13,255);
  if (Length(str) > 0) AND (Pos(',', str) > 0) then str[Pos(',', str)]:='.';
  val (str,antwort1,code);
  n2:=antwort1;

  until (n2 >= 1) AND (n2 <= 1500) AND (code = 0);

  gotoxy (1,12);
  writeln ('                          Sekund„rwindungszahl :                 ');
  writeln ('                                                                     ');
  gotoxy (49,12);
  write (n2:7:0);
  write (' Windungen');

  repeat

  gotoxy (1,14);
  writeln ('     Bitte geben Sie das Spannungsteilerverh„ltnis ein : (1:x)       ');
  writeln ('     (   Wertebereich des Spannungsteilers 1...100   )               ');
  readln (str);
  gotoxy (1,16);
  textbackground (black);
  write ('                                                                         ');
  gotoxy (1,17);
  write ('                                                                         ');
  textbackground (green);
  delete (str,13,255);
  if (Length(str) > 0) AND (Pos(',', str) > 0) then str[Pos(',', str)]:='.';
  val (str,antwort1,code);
  spgteiler:=antwort1;

  until (spgteiler >= 1) AND (spgteiler <= 100) AND (code = 0);

  if antwort1 = 1 then

  begin
    n2theo:=n2;
  end;

  if antwort1 <> 1 then

  begin
    n2theo:= n2 / spgteiler;
    {
    gotoxy (1,12);
    writeln ('             theoretische Sekund„rwindungszahl :                 ');
    writeln ('                                                                     ');
    gotoxy (50,12);
    write (n2theo:7:1);
    write (' Windungen');
    }
  end;

  gotoxy (1,14);
  writeln ('                   Spannungsteilerverh„ltins 1 :                 ');
  writeln ('                                                                     ');
  gotoxy (52,14);
  write (spgteiler:4:1);

  repeat

  gotoxy (1,16);
  writeln ('     Bitte geben Sie den Meáwiderstand in Ohm ein :                  ');
  writeln ('     (   Wertebereich des Meáwiderstandes 0,1...100   )                ');
  readln (str);
  gotoxy (1,18);
  textbackground (black);
  write ('                                                                         ');
  gotoxy (1,19);
  write ('                                                                         ');
  textbackground (green);
  delete (str,13,255);
  if (Length(str) > 0) AND (Pos(',', str) > 0) then str[Pos(',', str)]:='.';
  val (str,antwort1,code);
  shunt:=antwort1;

  until (shunt >= 0.1) AND (shunt <= 100) AND (code = 0);

  gotoxy (1,16);
  writeln ('                            Meáwiderstandswert :                 ');
  writeln ('                                                                     ');
  gotoxy (49,16);
  write (shunt:9:1);
  write (' [Ohm]');

  { Umrechnungsfaktoren berechnen }
  faktor1:= (1000000 / (n2theo * a));    { Spg in Fluádichte nach Int. in V/m^2 }
  faktor2:= ((n1 * 100) / (lm * shunt)); { Spg in magn. Feldst„rke in A/m }

  textbackground (cyan);
  gotoxy(1,22);
  writeln ('   Sind alle Eingabewerte richtig ?                                  ');
  textcolor (blink);
  gotoxy (60,22);
  write ('(J / N)');
  textcolor (black);
  sound (1250);
  delay (250);
  nosound;

  repeat

  antwort2:=readkey

  until antwort2 in ['J','j','N','n'];

  until antwort2 in ['J','j'];

  textbackground (black);
  textcolor (white);
end; { ENDE EINGABE1 }
{
**************************************************************************
}
Procedure EINGABE2; 
{***********************************
erst.: am 22.11.94 von M.Schweizer

EINGABE2:
Hier werden folgende Werte eingelesen:
   freq     : integer;      Ein_par : Frequenz
   b_gew    : single;       gew„hlte Fluádichte

ge„n.: am 15.01.99  von U. Weidlich
       Untere Frequenzgrenze auf 10Hz ge„ndert
       zweite REPEAT-Schleife bei den Eingaben entfernt; alle Bedingungen werden
       in einer UNTIL-Anweisung geprft. Zus„tzliche šberprfung, ob die
       Umwandlung in einen numerischen Wert erfolgreich war.
       Tempor„re Variablen antwort1, antwort2 entfernt.

***********************************}
var
   antwort : char;
   str      : string[20];
   code     : integer;

begin

  repeat

  textbackground (black);
  textcolor (black);
  window (1,1,78,24);
  clrscr;
  textbackground (green);
  window (6,2,78,24);

  repeat

  gotoxy (1,1);
  writeln ('                                                                     ');
  writeln ('     Bitte geben Sie die gewnschte magn. Fluádichte in [T] ein :    ');
  writeln ('     (   Wertebereich der Fluádichte ( 0.001...5 [T]   )             ');
  writeln ('                                                                     ');
  readln (str);
  gotoxy (1,5);
  textbackground (black);
  write ('                                                                          ');
  gotoxy (1,6);
  write ('                                                                          ');
  textbackground (green);
  delete (str,13,255);
  if (Length(str) > 0) AND (Pos(',', str) > 0) then str[Pos(',', str)]:='.';
  val (str,b_gew,code);

  until (b_gew > 0.0009) AND (b_gew <= 5) AND (code = 0);

  gotoxy (1,2);
  writeln ('                         gewnschte Fluádichte :                 ');
  writeln ('                                                                     ');
  gotoxy (53,2);
  write (b_gew:7:5);
  write (' [T]');
  b_gewu:=b_gew;

  repeat

  gotoxy (1,5);
  writeln ('     Bitte geben Sie die gewnschte Frequenz in [Hz] ein :           ');
  writeln ('     (   Wertebereich der Frequenz : 10....5000 [Hz]    )            ');
  writeln ('                                                                     ');
  readln (str);
  gotoxy (1,8);
  textbackground (black);
  write ('                                                                          ');
  gotoxy (1,9);
  write ('                                                                          ');
  textbackground (green);
  delete (str,8,255);
  if (Length(str) > 0) AND (Pos(',', str) > 0) then str[Pos(',', str)]:='.';
  val (str,freq,code);

  until (freq >= 10) AND (freq <= 5000) AND (code = 0);

  gotoxy (1,5);
  writeln ('                           gewnschte Frequenz :                 ');
  writeln ('                                                                     ');
  gotoxy (51,5);
  write (freq:7);
  write (' [Hz]');

  textbackground (cyan);
  gotoxy(1,22);
  writeln ('   Sind alle Eingabewerte richtig ?                                  ');
  textcolor (blink);
  gotoxy (60,22);
  write ('(J / N)');
  sound (1250);
  delay (250);
  nosound;

  repeat

  antwort:=readkey

  until antwort in ['J','j','N','n'];

  until antwort in ['J','j'];

  textbackground (black);
  textcolor (white);
end; { ENDE EINGABE2 }
{
*********************************************************************
}
begin
end.