Unit MELDUNG;

Interface

Uses CRT,VARDEF,IEEEPAS;

{
**************************************************************************
}
Procedure MELDUNG0;    { Frequenz 'x' eingestellt }
Procedure MELDUNG1;    { Anpassung magn. Flu�dichte l�uft }
Procedure MELDUNG2;    { max. Flu�dichte erreicht,weiter mit Wert ? J/N }
Procedure MELDUNG21;   { Entmagnetisierung l�uft }
Procedure MELDUNG3;    { erreichte Flu�dichte }
Procedure MELDUNG31;   { Flu�dichte Angabe noch nicht m�glich }
Procedure MELDUNG32;   { erreichte Flu�dichte }
Procedure MELDUNG4;    { Messung der Hystereseschleife l�uft }
Procedure MELDUNG5;    { Messung der Hystereseschleife abgeschlossen }
Procedure MELDUNG6;    { Entmagnetisierung l�uft }
Procedure MELDUNG7;    { Entmagnetisierung abgeschlossen }
Procedure MELDUNG8;    { Wollen Sie die Kommutierungskurve messen ? J/N }
Procedure MELDUNG81;   { Kom Messung nicht m�glich }
Procedure MELDUNG82;   { Kom Messung war nicht m�glich }
Procedure MELDUNG9;    { Messung Kom l�uft }
Procedure MELDUNG10;   { Messung Kom abgeschlossen }
Procedure MELDUNG11;   { Entmagnetisierung l�uft }
Procedure MELDUNG12;   { Entmagnetisierung abgeschlossen }
Procedure MELDUNG13;   { neue Frequenz+Flu�dichtewerte eingeben ? J/N }
                       { bei N = Sie w�nschen keine Werte einzugeben }
Procedure MELDUNG14;   { neue Probenspezifikationen eingeben ? J/N }
                       { bei N = Sie w�nschen keine Prob.spez. einzugeben }
Procedure MELDUNG15;   { Neue Messnummer eingeben ? J/N }
{
**************************************************************************
**************************************************************************
}

Implementation

Procedure MELDUNG0;
{
erst.: am 22.11.94 von M.Schweizer
ge�n.: am
was  :
}
var
   status   : integer;

begin
  window (1,1,78,24);
  clrscr;
  window (6,2,78,24);
  textbackground (green);
  textcolor (black);
  gotoxy(1,1);
  writeln('                                                                      ');
  writeln('                 Frequenz : ',(freq):7,' Hz  eingestellt !                 ');
  writeln('                                                                      ');
  textbackground (black);
  textcolor (white);
end; { ENDE MELDUNG0 }
{
**************************************************************************
}
Procedure MELDUNG1;
{
erst.: am 22.11.94 von M.Schweizer
ge�n.: am
was  :
}
begin
  window (6,5,78,24);
  textbackground (blue);
  textcolor (yellow+blink);
  gotoxy(1,1);
  writeln('                                                                      ');
  writeln('                Anpassung der magn. Flu�dichte l�uft !                ');
  writeln('                                                                      ');
  textbackground (black);
  textcolor (white);
end; { ENDE MELDUNG1 }
{
***************************************************************************
}
Procedure MELDUNG2;
{***********************************
erst.: am 22.11.94 von M.Schweizer
ge�n.: am
was  :
Folgender Merker wird gesetzt:
   merker4  : boolean
***********************************}
var
   antwort : char;

begin
  clrscr;
  window (6,5,78,24);
  textbackground (green);
  textcolor (black);
  gotoxy(1,1);
  writeln('                                                                      ');
  writeln('              maximal erreichte Flu�dichte:          [T]              ');
  writeln('                                                                      ');
  gotoxy(46,2);
  write (b_gew:7:4);
  window (6,10,78,24);
  textbackground (cyan);
  gotoxy(1,1);
  writeln('                                                                      ');
  writeln('  Wollen Sie mit diesem Wert weiterrechnen ?                          ');
  writeln('                                                                      ');
  textcolor (blink);
  gotoxy (62,2);
  write ('(J / N)');
  textcolor (red);                                                
  textbackground(black);
  textcolor(white);

  repeat

  repeat

  sound (1250);
  delay (250);
  nosound;
  delay (2000);

  until keypressed;

  antwort:=readkey

  until antwort in ['j','J','n','N'];

  if antwort in ['n','N'] then

  begin
    clrscr;
    merker2:= true;
    exit;
  end;

  if antwort in ['j','J'] then

  begin
    clrscr;
  end;

end; { ENDE MELDUNG2 }
{
**************************************************************************
}    
Procedure MELDUNG21;
{
erst.: am 22.11.94 von M.Schweizer
ge�n.: am
was  :
}
var
   antwort : char;

begin
  window (6,1,78,24);
  textbackground (blue);
  textcolor (yellow+blink);
  gotoxy(1,1);
  writeln('                                                                      ');
  writeln('                        Entmagnetisierung l�uft !                     ');
  writeln('                                                                      ');
  textbackground (black);
  textcolor (white);
end;  { ENDE MELDUNG21 }
{
***************************************************************************
}

Procedure MELDUNG3;
{
erst.: am 22.11.94 von M.Schweizer
ge�n.: am
was  :
}
var
   b_anz   :single;

begin
  window (6,5,78,24);
  clrscr;
  textbackground (green);
  textcolor (black);
  gotoxy(1,1);
  writeln('                                                                      ');
  writeln('                  erreichte Flu�dichte:          [T]                  ');
  writeln('                                                                      ');
  b_anz:=b_gew;
  gotoxy(42,2);
  write (b_anz:7:4);
  textbackground (black);
  textcolor (white);
end; { ENDE MELDUNG3 }
{
***************************************************************************
}
Procedure MELDUNG31;
{
erst.: am 22.11.94 von M.Schweizer
ge�n.: am
was  :
}
begin
  clrscr;
  window (6,5,78,24);
  textbackground (blue);
  textcolor (yellow+blink);
  gotoxy(1,1);
  writeln('                                                                      ');
  writeln('                Flu�dichteangabe noch nicht m�glich !                 ');
  writeln('                                                                      ');
  textbackground (black);
  textcolor (white);
end; { ENDE MELDUNG31 }
{
***************************************************************************
}
Procedure MELDUNG32;
{
erst.: am 22.11.94 von M.Schweizer
ge�n.: am
was  :
}
var
   b_anz   :single;

begin
  clrscr;
  window (6,5,78,24);
  textbackground (green);
  textcolor (black);
  gotoxy(1,1);
  writeln('                                                                      ');
  writeln('                  erreichte Flu�dichte:          [T]                  ');
  writeln('                                                                      ');
  b_anz:=b_gew;
  gotoxy(42,2);
  write (b_anz:7:4);
  textbackground (black);
  textcolor (white);
end; { ENDE MELDUNG32 }
{
**************************************************************************
}
Procedure MELDUNG4;
{
erst.: am 22.11.94 von M.Schweizer
ge�n.: am
was  :
}
begin
  window (6,8,78,24);
  textbackground (blue);
  textcolor (yellow+blink);
  gotoxy(1,1);
  writeln('                                                                      ');
  writeln('                Messung der Hystereseschleife l�uft !                 ');
  writeln('                                                                      ');
  textbackground (black);
  textcolor (white);
end; { ENDE MELDUNG4 }
{
**************************************************************************
}
Procedure MELDUNG5;
{
erst.: am 22.11.94 von M.Schweizer
ge�n.: am
was  :
}
var
   antwort : char;

begin
  window (6,8,78,24);
  textbackground (green);
  textcolor (black);
  gotoxy(1,1);
  writeln('                                                                      ');
  writeln('            Messung der Hystereseschleife abgeschlossen !             ');
  writeln('                                                                      ');
  textbackground (black);
  textcolor (white);
end;  { ENDE MELDUNG5 }
{
**************************************************************************
}    
Procedure MELDUNG6;
{
erst.: am 22.11.94 von M.Schweizer
ge�n.: am
was  :
}
var
   antwort : char;

begin
  window (6,11,78,24);
  textbackground (blue);
  textcolor (yellow+blink);
  gotoxy(1,1);
  writeln('                                                                      ');
  writeln('                        Entmagnetisierung l�uft !                     ');
  writeln('                                                                      ');
  textbackground (black);
  textcolor (white);
end;  { ENDE MELDUNG6 }
{
**************************************************************************
}
Procedure MELDUNG7;
{
erst.: am 22.11.94 von M.Schweizer
ge�n.: am
was  :
}
var
   antwort : char;

begin
  window (6,11,78,24);
  textbackground (green);
  textcolor (black);
  gotoxy(1,1);
  writeln('                                                                      ');
  writeln('                   Entmagnetisierung abgeschlossen !                  ');
  writeln('                                                                      ');
  textbackground (black);
  textcolor (white);
end;  { ENDE MELDUNG7 }
{
**************************************************************************
}
Procedure MELDUNG8;
{***********************************
erst.: am 22.11.94 von M.Schweizer
ge�n.: am
was  :
Folgender Merker wird gesetzt:
   merker8  : boolean
***********************************}
var
   antwort : char;

begin
  window (6,16,78,24);
  textbackground (cyan);
  textcolor (black);
  gotoxy(1,1);
  writeln('                                                                      ');
  writeln('         Wollen Sie die Kommutierungskurve messen ?                   ');
  writeln('                                                                      ');
  textcolor (blink);
  gotoxy (62,2);
  write ('(J / N)');
  textbackground(black);
  textcolor(white);

  repeat

  repeat

  sound (1250);
  delay (250);
  nosound;
  delay (2000);

  until keypressed;

  antwort:=readkey

  until antwort in ['j','J','n','N'];

  if antwort in ['n','N'] then

  begin
    clrscr;
    merker3:= true;
    exit;
  end;

  if antwort in ['j','J'] then

  begin
    clrscr;
    merker3:= false;
  end;

end; { ENDE MELDUNG8 }
{
**************************************************************************
}
Procedure MELDUNG81;
{
erst.: am 22.11.94 von M.Schweizer
ge�n.: am
was  :
}
begin
  window (6,16,78,24);
  textbackground (green);
  textcolor (black);
  gotoxy(1,1);
  writeln('                                                                      ');
  writeln('            Messung der Kommutierungskurve nicht m�glich !            ');
  writeln('                                                                      ');
  delay (4000);
  textbackground(black);
  textcolor(white);
end; { ENDE MELDUNG81 }
{
**************************************************************************
}
Procedure MELDUNG82;
{
erst.: am 22.11.94 von M.Schweizer
ge�n.: am
was  :
}
begin
  window (6,14,78,24);
  textbackground (green);
  textcolor (black);
  gotoxy(1,1);
  writeln('                                                                      ');
  writeln('          Messung der Kommutierungskurve war nicht m�glich !          ');
  writeln('                                                                      ');
  textbackground(black);
  textcolor(white);
end; { ENDE MELDUNG82 }
{
**************************************************************************
}
Procedure MELDUNG9;
{
erst.: am 22.11.94 von M.Schweizer
ge�n.: am
was  :
}
begin
  window (6,14,78,24);
  textbackground (blue);
  textcolor (yellow+blink);
  gotoxy(1,1);
  writeln('                                                                      ');
  writeln('                Messung der Kommutierungskurve l�uft !                ');
  writeln('                                                                      ');
  textbackground (black);
  textcolor (white);
end; { ENDE MELDUNG9 }
{
**************************************************************************
}
Procedure MELDUNG10;
{
erst.: am 22.11.94 von M.Schweizer
ge�n.: am
was  :
}
var
   antwort : char;

begin
  window (6,14,78,24);
  textbackground (green);
  textcolor (black);
  gotoxy(1,1);
  writeln('                                                                      ');
  writeln('            Messung der Kommutierungskurve abgeschlossen !            ');
  writeln('                                                                      ');
  textbackground (black);
  textcolor (white);
end;  { ENDEMELDUNG10 }
{
**************************************************************************
}    
Procedure MELDUNG11;
{
erst.: am 22.11.94 von M.Schweizer
ge�n.: am
was  :
}
var
   antwort : char;

begin
  window (6,17,78,24);
  textbackground (blue);
  textcolor (yellow+blink);
  gotoxy(1,1);
  writeln('                                                                      ');
  writeln('                        Entmagnetisierung l�uft !                     ');
  writeln('                                                                      ');
  textbackground (black);
  textcolor (white);
end;  { ENDE MELDUNG11 }
{
**************************************************************************
}
Procedure MELDUNG12;
{
erst.: am 22.11.94 von M.Schweizer
ge�n.: am
was  :
}
var
   antwort : char;

begin
  window (6,17,78,24);
  textbackground (green);
  textcolor (black);
  gotoxy(1,1);
  writeln('                                                                      ');
  writeln('                   Entmagnetisierung abgeschlossen !                  ');
  writeln('                                                                      ');
  textbackground (black);
  textcolor (white);
end;  { ENDE MELDUNG12 }
{
**************************************************************************
}   
Procedure MELDUNG13;
{***********************************
erst.: am 22.11.94 von M.Schweizer
ge�n.: am
was  :
Folgender Merker wird gesetzt:
   merker 5  : boolean
***********************************}
var
   antwort : char;

begin
  window (6,20,78,24);
  textbackground (cyan);
  textcolor (black);
  gotoxy(1,1);
  writeln('                                                                      ');
  writeln(' W�nschen Sie neue Frequenz oder Flu�dichtewerte einzugeben           ');
  writeln('                                                                      ');
  textcolor (blink);
  gotoxy (62,2);
  write ('(J / N)');
  textcolor (red);                                                
  textbackground(black);
  textcolor(white);

  repeat

  repeat

  sound (1250);
  delay (250);
  nosound;
  delay (1000);

  until keypressed;

  antwort:=readkey

  until antwort in ['j','J','n','N'];

  if antwort in ['n','N'] then

  begin
    clrscr;
    window (6,20,78,24);
    textbackground (green);
    textcolor (black);
    gotoxy(1,1);
    writeln('                                                                      ');
    writeln('  Sie w�nschen keine neuen Frequenz oder Flu�dichtewerte einzugeben   ');
    writeln('                                                                      ');
    merker5:= true;
    delay (1500);
    exit;
  end;

  if antwort in ['j','J'] then

  begin
    clrscr;
  end;

end; { ENDE MELDUNG13 }
{
**************************************************************************
}    
Procedure MELDUNG14;
{***********************************
erst.: am 22.11.94 von M.Schweizer
ge�n.: am
was  :
Folgender Merker wird gesetzt:
   merker6  : boolean
***********************************}
var
   antwort : char;

begin
  window (6,20,78,24);
  textbackground (cyan);
  textcolor (black);
  gotoxy(1,1);
  writeln('                                                                      ');
  writeln('  W�nschen Sie neue Probenspezifikationen einzugeben ?                ');
  writeln('                                                                      ');
  textcolor (blink);
  gotoxy (62,2);
  write ('(J / N)');
  textbackground(black);
  textcolor(white);

  repeat

  repeat

  sound (1250);
  delay (250);
  nosound;
  delay (1000);

  until keypressed;

  antwort:=readkey

  until antwort in ['j','J','n','N'];

  if antwort in ['n','N'] then

  begin
    clrscr;
    window (6,20,78,24);
    textbackground (green);
    textcolor (black);
    gotoxy(1,1);
    writeln('                                                                      ');
    writeln('      Sie w�nschen keine neuen Probenspezifikationen einzugeben       ');
    writeln('                                                                      ');
    merker6:= true;
    delay (1500);
    exit;
  end;

  if antwort in ['j','J'] then

  begin
    clrscr;
  end;

end; { ENDE MELDUNG14 }
{
**************************************************************************
}   
Procedure MELDUNG15;
{***********************************
erst.: am 22.11.94 von M.Schweizer
ge�n.: am
was  :
Folgender Merker wird gesetzt:
   merker10 : boolean
***********************************}
var
   antwort : char;

begin
  window (6,20,78,24);
  textbackground (cyan);
  textcolor (black);
  gotoxy(1,1);
  writeln('                                                                      ');
  writeln('             W�nschen Sie eine neue Messnummer einzugeben             ');
  writeln('                                                                      ');
  textcolor (blink);
  gotoxy (62,2);
  write ('(J / N)');
  textcolor (red);                                                
  textbackground(black);
  textcolor(white);

  repeat

  repeat

  sound (1250);
  delay (250);
  nosound;
  delay (1000);

  until keypressed;

  antwort:=readkey

  until antwort in ['j','J','n','N'];

  if antwort in ['n','N'] then

  begin
    clrscr;
    window (6,20,78,24);
    merker10:= true;
    exit;
  end;

  if antwort in ['j','J'] then

  begin
    clrscr;
  end;

end; { ENDE MELDUNG15 }
{
**************************************************************************
}    
begin
end.