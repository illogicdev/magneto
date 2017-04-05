{$N+,E+}
Unit Grafik;
Interface

Uses GRAPH,CRT,VARDEF,DOS,GERAETE;

{
*********************************************************************
}
Procedure GRAFIK0;
Procedure GRAFIK1;
Procedure GRAFIK2;
Procedure GRAFIK3;
Procedure DRUCK;
{
*********************************************************************
*********************************************************************
}
Implementation

var
   Driver     : Integer;
   Mode       : Integer;
   code       : Integer;
   graf_x     : Integer;
   graf_y     : Integer;
   xhys0      : LongInt;     { Nullpunkt der Hystereseschleife }
   yhys0      : LongInt;     { Nullpunkt der Hystereseschleife }
   xkom0      : LongInt;
   ykom0      : LongInt;
   diffxh     : LongInt;     { maximale Me·breite x Richtung hys }
   diffyh     : LongInt;     { maximale Me·breite y Richtung hys }
   diffxk     : LongInt;     { maximale Me·breite x Richtung kom }
   diffyk     : LongInt;     { maximale Me·breite y Richtung kom }
   freq       : Integer;
   bmaxgr1    : Single;
   hmaxgr1    : Single;
   bmaxsk1    : string;
   bmaxsk2    : string;
   bmaxi3     : longint;
   bmaxn5     : double;
   hmaxsk1    : string;
   hmaxsk2    : string;
   hmaxi3     : longint;
   hmaxn5     : double;
   xmaxsk1    : string;  { Skalierungsfaktoren y-Achse }
   xmaxsk2    : string;  { Exponent y-Achse }
   xmaxi3     : longint;
   xmaxn5     : double;
   zw1        : single;
   zw2        : single;
   zw3        : LongInt;
   zw4        : LongInt;
{
*********************************************************************
}

Function x_wert (x:single):Integer;
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
x_wert:
Umrechnen Bildschirmkoordinate % in Pixel.
***********************************}
begin
  {*} ABBRUCH;
  zw1:=x / 100;
  zw2:=zw1 * graf_x;
  x_wert:= round ( zw2 );
end;

Function y_wert (y:single):Integer;
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
y_wert:
Umrechnen Bildschirmkoordinate % in Pixel.
***********************************}
begin
  {*} ABBRUCH;
  zw1:= y / 100;
  zw2:=zw1 * graf_y;
  y_wert:= round ( zw2 );
end;

Function x_hys (x:single):LongInt;
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
x_hys:
Me·wert bezogen auf den Nullpunkt der Hystereseschleife in x Richtung in Pixel.
***********************************}
begin
  {*} ABBRUCH;
  zw1:=diffxh / hmaxgr1;
  zw2:=zw1 * x;
  zw3:= round ( zw2 );
  zw4:=zw3 + xhys0;
  x_hys:=zw4;
end;

Function y_hys (y:single):LongInt;
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
y_hys:
Me·wert bezogen auf den Nullpunkt der Hystereseschleife in y Richtung in Pixel.
***********************************}
begin
  {*} ABBRUCH;
  zw1:=diffyh / bmaxgr1;
  zw2:=zw1 * y;
  zw3:= round ( zw2 );
  zw4:=yhys0 - zw3;
  y_hys:=zw4;
end;

Function x_kom (x:single):LongInt;
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
x_kom:
Me·wert bezogen auf den Nullpunkt der Kommutierungskurve in x Richtung in Pixel.
***********************************}
begin
  {*} ABBRUCH;
  zw1:=diffxk / hmaxgr1;
  zw2:=zw1 * x;
  zw3:= round ( zw2 );
  zw4:=zw3 + xkom0;
  x_kom:=zw4;
end;

Function y_kom (y:single):LongInt;
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
y_kom:
Me·wert bezogen auf den Nullpunkt der Kommutierungskurve in y Richtung in Pixel.
***********************************}
begin
  {*} ABBRUCH;
  zw1:=diffyk / bmaxgr1;
  zw2:=zw1 * y;
  zw3:= round ( zw2 );
  zw4:=ykom0 - zw3;
  y_kom:=zw4;
end;

Procedure Linie (x1,y1,x2,y2:single);
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
Linie:
Linienzug. Eingabe in %
***********************************}
begin
  {*} ABBRUCH;
  Line (x_wert (x1),y_wert (y1),x_wert (x2),y_wert (y2));
end;

Procedure Schleife1 (x1,y1,x2,y2:single);
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
Schleife1:
Linienzug. Eingabe in T oder A/m.
***********************************}
begin
  {*} ABBRUCH;
  Line (x_hys (x1),y_hys (y1),x_hys (x2),y_hys (y2));
end;

Procedure Schleife2 (x1,y1,x2,y2:single);
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
Schleife2:
Linienzug. Eingabe in T oder A/m.
***********************************}
begin
  {*} ABBRUCH;
  Line (x_kom (x1),y_kom (y1),x_kom (x2),y_kom (y2));
end;

Procedure Umrechnung (var xmaxsk1 : string;
                      var xmaxsk2 : string;
                      var xmaxi3  : longint;
                      var xmaxn5  : double );
{***********************************
erst.: am 22.11.94 von M.Schweizer
       Bmax und Hmax Werte werden in das richtige Anzeigeformat gebracht.
       Herausfiltern der Mantisse.
geÑn.: am 02.05.1995 von U.Weidlich
was  : Anpassung an Turbo Pascal 7.0 (weil chaotisch programmiert);
       funktioniert auch mit Turbo Pascal 6.0
       Umrechnung:

***********************************}
var
  xmaxsk3   : string;
  xmaxsk4   : string;
  xmaxn3    : single;
  xmaxn4    : double;
  code      : Integer;

begin
  {*}ABBRUCH;
  delete ( xmaxsk1,20,2 );
  delete ( xmaxsk1,7,11 );
  xmaxsk2:=xmaxsk1;
  delete ( xmaxsk2,1,6 );       { neue Version (Turbo Pascal 6.0/7.0) }
  xmaxsk3:=xmaxsk1;
  delete ( xmaxsk3,7,255 );
  val ( xmaxsk3,xmaxn3,code );
  xmaxn3:=round ( 0.49 + xmaxn3 );
  xmaxi3:=round ( xmaxn3 );
  str ( xmaxi3,xmaxsk4 );
  delete ( xmaxsk4,3,255 );
  xmaxsk4:=concat ( xmaxsk4,xmaxsk2);
  val ( xmaxsk4,xmaxn4,code );
  xmaxn5:=xmaxn4/xmaxn3;
end;

Procedure x_achse_hys ( x1,y1,x2,y2 : single );
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
x_achse_hys:
Skalenteile einfÅgen x Achse Hystereseschleife.
***********************************}
begin
  {*} ABBRUCH;
  Line ( x_hys (x1),y_wert (y1),x_hys (x2),y_wert (y2));
end;

Procedure y_achse_hys ( x1,y1,x2,y2 : single );
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
y_achse_hys:
Skalenteile einfÅgen y Achse Hystereseschleife.
***********************************}
begin
  {*} ABBRUCH;
  Line ( x_wert (x1),y_hys (y1),x_wert (x2),y_hys (y2));
end;

Procedure x_achse_kom ( x1,y1,x2,y2 : single );
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
x_achse_kom:
Skalenteile einfÅgen x Achse Kommutierungskurve.
***********************************}
begin
  {*} ABBRUCH;
  Line ( x_kom (x1),y_wert (y1),x_kom (x2),y_wert (y2));
end;

Procedure y_achse_kom ( x1,y1,x2,y2 : single );
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
y_achse_kom:
Skalenteile einfÅgen y Achse Kommutierungskurve.
***********************************}
begin
  {*} ABBRUCH;
  Line ( x_wert (x1),y_kom (y1),x_wert (x2),y_kom (y2));
end;
{
********************************************************************
********************************************************************
}
Procedure GRAFIK0;
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am 24.02.99 von U. Weidlich
was  : n2theo wird nicht in der Graphik angezeigt
       die Information ist fÅr den Nutzer des Programmes wertlos
Grafik0:
Auslesen der angezeigten Werte aus Datei.
Zeichnet die Blattumrandung.
Textangaben und Informationsausgabe.
***********************************}
var
  xdat         : text;
  bmax1_s      : string;
  hmax1_s      : string;
  punkte_s     : string;
  text_pr_s    : string;
  lm_s         : string;
  a_s          : string;
  Dichte_s     : string;
  n1_s         : string;
  n2_s         : string;
  n2theo_s     : string;
  spgteiler_s  : string;
  shunt_s      : string;
  b_gew_s      : string;
  freq_s       : string;
  b_gewu_s     : string;
  hc_s         : string;
  br_s         : string;
  hys_ver_s    : string;
  messnr_s1    : string;

  merker_freq_s: string;

  pu_gr_500_s  : string;

  BMax: Single;
  HMax: Single;
  BMaxStr: String;

begin
  {*}ABBRUCH;
  Driver:=Detect;
  InitGraph (Driver,Mode,'');
  str (messnr,messnr_s);
  { Maximalpixlezahl feststellen }
  graf_x:=getmaxx;
  graf_y:=getmaxy;
  { Umrandung Blatt }
  linie (0,10.4,100,10.4);
  linie (0,0,100,0);
  linie (0,0,0,100);
  linie (0,100,100,100);
  linie (100,0,100,100);
  { Bezugsdaten auslesen }
  assign ( xdat,messnr_s+'was.dat');
  reset ( xdat );
  readln ( xdat,bmax1_s );
  readln ( xdat,hmax1_s );
  readln ( xdat,punkte_s );
  readln ( xdat,text_pr_s );
  readln ( xdat,lm_s );
  readln ( xdat,a_s );
  readln ( xdat,Dichte_s );
  readln ( xdat,n1_s );
  readln ( xdat,n2_s );
  readln ( xdat,n2theo_s );
  readln ( xdat,spgteiler_s );
  readln ( xdat,shunt_s );
  readln ( xdat,b_gew_s );
  readln ( xdat,freq_s );
  readln ( xdat,b_gewu_s );
  readln ( xdat,Hc_s );
  readln ( xdat,Br_s );
  readln ( xdat,hys_ver_s );
  readln ( xdat,messnr_s1 );
  readln ( xdat,pu_gr_500_s );
  close ( xdat );
  val (freq_s,freq,code);
  val (pu_gr_500_s,pu_gr_500,code);
  Val(bmax1_s, BMax, Code);
  Val(hmax1_s, HMax, Code);

  delete (hc_s,20,2);           { Anpassen der Remanenz und der    }
  delete (br_s,20,2);           { KoerzitivfeldstÑrke an geeignete }
  delete (bmax1_s,20,2);        { Anzeigewerte                     }
  delete (hmax1_s,20,2);
  delete (hys_ver_s,20,2);
  delete (hc_s,6,11);
  delete (br_s,6,11);
  delete (bmax1_s,6,11);
  delete (hmax1_s,6,11);
  delete (hys_ver_s,7,11);
  { Ausgabe der ermittelten Werte }
  {*}ABBRUCH;
  settextjustify (LeftText,CenterText);
  settextstyle (SansSerifFont,HorizDir,2);
  outtextxy (28,25,text_pr_s);
  settextjustify (CenterText,CenterText);
  Str(BMax:6:4, BMaxStr);
  outtextxy (320,25,BMaxStr+' T');
  settextjustify (RightText,CenterText);
  outtextxy (612,25,freq_s+' Hz');
  settextjustify (LeftText,CenterText);
  settextstyle (SmallFont,HorizDir,4);
  outtextxy (45,464,hc_s);
  outtextxy (45,449,br_s);
  outtextxy (10,64,messnr_s1);
  settextjustify (RightText,CenterText);
  outtextxy(609,65,lm_s);
  outtextxy(609,75,a_s);
  outtextxy(609,85,dichte_s);
  outtextxy(609,105,n1_s);
  outtextxy(609,115,n2_s);
  {
    n2theo wird nicht in der Graphik angezeigt
    die Information ist fÅr den Nutzer des Programmes wertlos
  }
  { outtextxy(609,125,n2theo_s); }

  outtextxy(609,145,spgteiler_s);
  outtextxy(609,155,shunt_s);
  outtextxy(609,195,hys_ver_s+'W/kg Verlustleistung');
  if freq > 500 then
  begin
  outtextxy(609,215,pu_gr_500_s+' Messpunkte');
  end;
  if freq <= 500 then
  begin
  outtextxy(609,215,punkte_s+' Messpunkte');
  end;
  outtextxy(609,175,'Bmax : '+bmax1_s+' T  ');
  outtextxy(609,185,'Hmax : '+hmax1_s+' A/m');
  {*} ABBRUCH;
end; { ENDE GRAFIK0 }
{
********************************************************************
}
Procedure GRAFIK1;
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
Grafik1:
Erstellen des Koordinatensystems fÅr die Hystereseschleife.
Beschriften des Koordinatensystems.
Erstellen und berechnen der Skalierung fÅr die Hystereseschleife.
Zeichnen der Hystereseschleife.
***********************************}
var
   x      : single;
   y      : single;
   x1     : single;
   y1     : single;
   x2     : single;
   y2     : single;
   xhys1  : Integer;
   yhys2  : Integer;
   mdat   : text;     { hys,neu,kom.dat }
   xdat   : text;     { was.dat }
   i      : integer;  { laufindex }

begin
  {*}ABBRUCH;
  New ( BMess );
  New ( HMess );
  { Daten auslesen als string : bmaxsk1,hmaxsk1 }
  assign ( xdat,messnr_s+'was.dat');
  reset ( xdat );

  begin
    readln ( xdat,bmaxsk1 );
    readln ( xdat,hmaxsk1 );
  end;

  close ( xdat );         
  {*} Umrechnung ( bmaxsk1,bmaxsk2,bmaxi3,bmaxn5 );
  {*} Umrechnung ( hmaxsk1,hmaxsk2,hmaxi3,hmaxn5 );
  { Daten auslesen : bmax1,hmax1,punkte }
  assign ( xdat,messnr_s+'was.dat');
  reset ( xdat );

  begin
    readln ( xdat,bmax1 );
    readln ( xdat,hmax1 );
    readln ( xdat,punkte );
  end;

  close ( xdat );
  { Fadenkreuz Hysterese }
  linie (7.35,55.2,55.88,55.2);
  linie (31.61,20,31.61,90.4);
  { Beschriftung Fadenkreuz Hysterese }
  settextjustify (LeftText,CenterText);
  outtextxy(213,80,bmaxsk2+'T');
  outtextxy(10,222,hmaxsk2);
  outtextxy(10,232,' A/m');
  outtextxy(213,90,'/div');
  outtextxy(10,242,'/div');
  settextjustify (RightText,BottomText);
  outtextxy(185,94,'B');
  settextjustify (LeftText,TopText);
  outtextxy(370,280,'H');
  settextstyle (SmallFont,HorizDir,4);
  { Pixel der Koordinaten feststellen }
  xhys0:=x_wert (31.61);
  yhys0:=y_wert (55.2);
  xhys1:=x_wert (55.88);
  yhys2:=y_wert (22.91);
  { Differenz der Punkte feststellen }
  diffxh:=xhys1 - xhys0;
  diffyh:=yhys0 - yhys2;
  { Skala Maximalwert festlegen }
  bmaxgr1:=bmax1 * 1.1;
  hmaxgr1:=hmax1 * 1.1;
  { Skalierung Hystereseschleife }
  for i:=1 to (hmaxi3) do

  begin
    x:= i * hmaxn5;
    x_achse_hys (x,54.2,x,56.2);
  end;

  {*}ABBRUCH;
  for i:=1 to (bmaxi3) do

  begin
    y:= i * bmaxn5;
    y_achse_hys (30.61,y,32.61,y);
  end;

  for i:=1 to (hmaxi3) do

  begin
    x:= i * (-hmaxn5);
    x_achse_hys (x,54.2,x,56.2);
  end;

  for i:=1 to (bmaxi3) do

  begin
    y:= i * (-bmaxn5);
    y_achse_hys (30.61,y,32.61,y);
  end;

  {*}ABBRUCH;
  { Werte aus Datei lesen }
  if freq <= 500 then

  begin
    assign (mdat,messnr_s+'hys.dat');
    reset ( mdat );
    for i:=1 to punkte+1 do
    readln (mdat,HMess^[i],BMess^[i]);
    close (mdat);
  end;

  if freq > 500 then

  begin
    assign (mdat,messnr_s+'hys.dat');
    reset ( mdat );
    for i:=1 to pu_gr_500+1 do
    readln (mdat,HMess^[i],BMess^[i]);
    close (mdat);
  end;

  {*}ABBRUCH;
  { Hystereseschleife zeichnen }
  if freq <= 500 then
  begin
    for i:=1 to punkte do
    Schleife1 (HMess^[i],BMess^[i],HMess^[i+1],BMess^[i+1]);
  end;

  if freq > 500 then
  begin
    for i:=1 to pu_gr_500 do
    Schleife1 (HMess^[i],BMess^[i],HMess^[i+1],BMess^[i+1]);
  end;

  Dispose ( BMess );
  Dispose ( HMess );
  {*} ABBRUCH;
end; { ENDE GRAFIK1 }
{
*********************************************************************
}
Procedure GRAFIK2;
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
Grafik2:
Erstellen des Koordinatensystems fÅr die Kommutierungskurve.
Beschriften des Koordinatensystems.
Erstellen und berechnen der Skalierung fÅr die Kommutierungskurve.
Zeichnen der Kommutierungskurve.
***********************************}
var
   x      : single;
   y      : single;
   x1     : single;
   y1     : single;
   x2     : single;
   y2     : single;
   xkom1  : Integer;
   ykom2  : Integer;
   mdat   : text;
   i      : Integer;
   a      : Integer;

begin
  {*}ABBRUCH;
  New ( BMess );
  New ( HMess );
  { Skala Kommutierungskurve }
  linie (66.91 , 53.12 , 66.91 , 90.62);
  linie (66.17 , 89.6 , 92.6 , 89.6);
  { Beschriftung Kommutierungskurve }
  outtextxy(440,248,bmaxsk2+'T');
  outtextxy(440,258,'/div');
  outtextxy(570,440,hmaxsk2);
  outtextxy(570,450,'A/m /div');
  { Pixel der Koordinaten feststellen }
  xkom0:=x_wert (66.91);
  ykom0:=y_wert (89.6);
  xkom1:=x_wert (92.6);
  ykom2:=y_wert (53.12);
  { Differenz der Punkte feststellen }
  diffxk:=xkom1 - xkom0;
  diffyk:=ykom0 - ykom2;
  { Skalierung Kommutierungskurve }
  for i:=1 to (hmaxi3) do

  begin
    x:= i * hmaxn5;
    x_achse_kom (x,88.6,x,90.6);
  end;

  for i:=1 to (bmaxi3-1) do

  begin
    y:= i * bmaxn5;
    y_achse_kom (67.91,y,65.91,y);
  end;

  a:=0;
  {*}ABBRUCH;
  { Werte aus Datei lesen }
  assign (mdat,messnr_s+'kom.dat');
  reset ( mdat );
  while not Eof(mdat) do

  begin
    a:=a+1;
    readln (mdat,HMess^[a],BMess^[a]);
  end;

  close (mdat);
  {*}ABBRUCH;
  { Kommutierungskurve zeichnen }
  for i:=1 to a-1 do
  Schleife2 (HMess^[i],BMess^[i],HMess^[i+1],BMess^[i+1]);
  a:=0;
  {*}ABBRUCH;
  { Werte aus Datei lesen }
  assign (mdat,messnr_s+'kom.dat');
  reset ( mdat );
  while not Eof(mdat) do

  begin
    a:=a+1;
    readln (mdat,HMess^[a],BMess^[a]);
  end;

  close (mdat);
  {*}ABBRUCH;
  { Neukurve zeichnen ersetzt durch }
  { Kommutierungskurve zeichnen }
  { wegen unzureichender Genauigkeit z. Zt. deaktiviert }
  {
  for i:=1 to a-1 do
  Schleife1 (HMess^[i],BMess^[i],HMess^[i+1],BMess^[i+1]);
  }
  Dispose ( BMess );
  Dispose ( HMess );
  {*} ABBRUCH;
end;  { ENDE GRAFIK2 }
{
*********************************************************************
}
Procedure GRAFIK3;
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
Grafik3:
Hardcopy vorbereiten und Entscheidung ob Druck.
Folgender Merker wird gesetzt:
   merker4  : boolean
***********************************}
var
   antwort : char;

begin
  {*} ABBRUCH;
  SetTextJustify(RightText,CenterText);
  SetFillStyle (EmptyFill,black);

  repeat

  repeat

  outtextxy(609,468,'Hardcopy J/N');
  delay (500);
  bar (450,460,635,475);
  delay (500);

  until KeyPressed;

  antwort:=readkey

  until antwort in ['j','J','n','N'];

  if antwort in ['j','J'] then

  begin
    SetFillStyle (EmptyFill,black);
    bar (450,460,635,475);
    outtextxy(600,468,'HS Esslingen - Elektrische WerkstoffprÅfung');
    merker4:= true;
  end;

  {*} ABBRUCH;

end;  { ENDE GRAFIK3 }
{
*********************************************************************
}
Procedure DRUCK;
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
Druck:
Aufruf zur Druckeraktivierung.
***********************************}
var
   proz_reg : registers;

begin
  {*}ABBRUCH;
  Intr (5,proz_reg);
end;  { ENDE DRUCK }
{
*********************************************************************
}
begin
end.