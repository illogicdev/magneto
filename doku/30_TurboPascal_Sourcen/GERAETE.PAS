Unit GERAETE;

Interface

Uses VARDEF,IEEEPAS,CRT,MATHE,MELDUNG;

{
**************************************************************************
}
Procedure ABBRUCH;
Procedure INITIALISIER;
Procedure OSZILLOSKOP_EINSTELLEN;
Procedure FREQ_EINST;
Procedure BANDBREITE1;
Procedure BANDBREITE2;
Procedure KANAL_INFO      ( var yin     : single;
                            var yor     : single;
                            var yre     : single;
                            var xin     : single);

Procedure MessbereichEinstellen(ch: integer);
Procedure FLUSSDICHTE_ANPASS;
Procedure PRUEF_ANPASS;

Procedure fgSpannungEinstellen(U:Single);
Procedure fgFrequenzEinstellen(Frequenz:Single);
Procedure fgInitialisieren;

{
**************************************************************************
**************************************************************************
}
Implementation

var
   adr_str  : string;
   status   : integer;
   info_str : string;
   code     : integer;
   r        : string;
   l        : word;
{
**************************************************************************
}
Procedure ABBRUCH;
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
ABBRUCH:
öberprÅft ob Control C zum Abbruch betÑtigt wurde.
***********************************}
var
   abfrage : char;

begin
  if KeyPressed then

  begin
    abfrage:=ReadKey;
    if abfrage = #0 then
    abfrage:=ReadKey
    else if abfrage=#3 then

    begin
      window(1,1,80,25);
      clrscr;
      writeln('Abbruch des Programmes durch control C ! ');
      ExitProc:=ExitSave;
      Halt;
    end;

  end;

end; { ENDE ABBRUCH }
{
**************************************************************************
}
Procedure INITIALISIER;
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am 02.03.1998 von U.Weidlich
was  : DCL (Device Clear) wird gesendet um alle GerÑte zurÅckzusetzen
INITIALISIER:
Initialisierung Oszilloskop und Frequenzgenerator.
Verriegelung der GerÑte gegen unbefugtes Bedienen.
***********************************}
var
   adr_str : string;

begin
  initialize (adr_pc,0);
  transmit ('DCL', status);
  str (adr_fg,adr_str);
  transmit ('MTA LISTEN '+adr_str+' REN '+adr_str,status);
  { Verriegelung des Frequenzgenerators }
  transmit ('LLO '+adr_str,status);
  fgInitialisieren;
  str (adr_os,adr_str);
  transmit ('MTA LISTEN '+adr_str+' REN '+adr_str,status);
  { Verriegelung des Oszilloskop's }
  send (adr_os,':SYSTEM:LOCK ON',status);
  {*} ABBRUCH;
end; { ENDE INITIALISIER }
{
**************************************************************************
}
Procedure OSZILLOSKOP_EINSTELLEN;
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am 28.01.99 von U. Weidlich
       Grundeinstellungen fÅr die Triggerung des Oszilloskops werden hier
       definiert.
       Triggerung auf extern umgestellt.

OSZILLOSKOP_EINSTELLEN:
Grundeinstellungen des Oszilloskop's.
***********************************}
begin
  send (adr_os,'*RST',status);
  send (adr_os,':TRIGGER:SOURCE EXTERNAL',status);
  send (adr_os,':TRIGGER:COUPLING DC',status);
  send (adr_os,':TRIGGER:LEVEL 2',status);
  send (adr_os,':TRIGGER:MODE NORMAL',status);
  send (adr_os,':TRIGGER:SLOPE POSITIVE',status);
  send (adr_os,':TRIGGER:REJECT HF',status);
  send (adr_os,':CHANNEL1:RANGE 40 V',status);
  send (adr_os,':CHANNEL2:RANGE 40 V',status);
  send (adr_os,':CHANNEL1:BWLIMIT ON',status);
  send (adr_os,':CHANNEL2:BWLIMIT ON',status);
  send (adr_os,':TIMEBASE:RANGE 20 MS',status);

  {$IFDEF DSO5012A}
    send (adr_os,':ACQUIRE:TYPE HRESOLUTION',status);
    send (adr_os,':WAVEFORM:FORMAT WORD', Status);
    send (adr_os,':WAVEFORM:BYTEORDER LSBFIRST', Status);
    send (adr_os,':WAVEFORM:UNSIGNED ON', Status);

    send (adr_os,':DISPLAY:CLEAR',status);
  {$ELSE}
    send (adr_os,':TRIGGER:POLARITY POSITIVE',status);
    send (adr_os,':DISPLAY:TEXT BLANK',status);
  {$ENDIF}

  {*} ABBRUCH;
end;  { ENDE OSZILLOSKOP_EINSTELLEN }
{
**************************************************************************
}
Procedure FREQ_EINST;
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am 02.03.1998 von U.Weidlich
was  : In Grundeinstellung des Funktionsgenerators DTY in DTY 50% geÑndert.
       Sonst wird ein SRQ angefordert.
FREQ_EINST:
Grundeinstellungen des Frequenzgenerators.
Anpassen der Bandbreite ( 3 fach ).
***********************************}
begin
  clrscr;

  fgFrequenzEinstellen(freq);

  bandbr:=( 1 / freq ) * 3 ;
  { Einzustellende Bandbreite am Oszilloskop }
  str (bandbr,info_str);
  send (adr_os,':TIMEBASE:RANGE '+info_str+' s',status);
  {*} ABBRUCH;
end;   { ENDE FREQ_EINST }

{
**************************************************************************
}

Procedure BANDBREITE1;
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
BANDBREITE1:
Umstellen der Bandbreite zur Messung der Hystereseschleife.
Anpassen der Bandbreite.
Frequenz > 500 Hz dann ist die Bandbreite 1/500 s
***********************************}
var bandbr_os:Single;
{
  Repeat/Until-Schleife eingefÅgt. Wenn Range des Oszilloskops wegen Rundung
  nicht ausreicht wird dieser vergrî·ert.
}
begin

  if freq <= 500 then

  begin
    bandbr:=1/freq;
    Repeat
      str (bandbr,info_str);
      send (adr_os,':TIMEBASE:RANGE '+info_str+' s',status);
      Send(adr_os, ':TIMEBASE:RANGE?', status);
      Enter(info_str, 255, l, adr_os, status);
      Val(info_str, bandbr_os, status);
      bandbr:=1.01*bandbr
    Until bandbr_os/(1/freq) >= 0.9999;
    merker_freq:=freq*bandbr_os;
  end;

  if freq > 500 then

  begin
    bandbr:=1/500;
    str (bandbr,info_str);
    send (adr_os,':TIMEBASE:RANGE '+info_str+' s',status);
    merker_freq:= (freq/500);
  end;

  {$IFDEF DSO5012A}
    send (adr_os,':DISPLAY:CLEAR',status);
  {$ELSE}
    send (adr_os,':DISPLAY:TEXT BLANK',status);
  {$ENDIF}

  {*} ABBRUCH;
end;   { ENDE BANDBREITE1 }
{
**************************************************************************
}
Procedure BANDBREITE2;
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
BANDBREITE2:
Umstellen der Bandbreite zur Messung der Neu und Kommutierungskurve
Anpassen der Bandbreite ( 5 fach ).
***********************************}
begin
  bandbr:=(1/freq)*5;
  str (bandbr,info_str);
  send (adr_os,':TIMEBASE:RANGE '+info_str+' s',status);

  {$IFDEF DSO5012A}
    send (adr_os,':DISPLAY:CLEAR',status);
  {$ELSE}
    send (adr_os,':DISPLAY:TEXT BLANK',status);
  {$ENDIF}

  {*} ABBRUCH;
end;   { ENDE BANDBREITE1 }
{
**************************************************************************
}
Procedure KANAL_INFO       ( var yin     : single;
                             var yor     : single;
                             var yre     : single;
                             var xin     : single);
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
KANAL_INFO:
Einholen von Kanalparametern des Oszilloskop's.
   var yin     : single
   var yor     : single
   var yre     : single
   var xin     : single
***********************************}
begin
  {*} ABBRUCH;
  send (adr_os,':WAVEFORM:YINCREMENT?',status);
  enter (r,255,l,adr_os,status);
  val (r,yin,code);
  send (adr_os,':WAVEFORM:YORIGIN?',status);
  enter (r,255,l,adr_os,status);
  val (r,yor,code);
  send (adr_os,':WAVEFORM:YREFERENCE?',status);
  enter (r,255,l,adr_os,status);
  val (r,yre,code);
  send (adr_os,':WAVEFORM:XINCREMENT?',status);
  enter (r,255,l,adr_os,status);
  val (r,xin,code);

  {*} ABBRUCH;
end;  { ENDE KANAL_INFO }

Procedure scMinMaxLesen(scAddr:Integer;
                        KanalNr:Byte;
                        var VMin, VMax:Single);
var code    : integer;
    status  : integer;
    r       : string;
    l       : word;
begin
  { UMin und UMax einlesen }
  Case KanalNr of
    1: Send(scAddr, ':MEASURE:SOURCE CHANNEL1', Status);
    2: Send(scAddr, ':MEASURE:SOURCE CHANNEL2', Status);
    else Halt(1);
  end;
  Send (scAddr,':MEASURE:VMAX?',Status);
  Enter (r, 255, l, scAddr, Status);
  Val (r, VMax, Code);
  Send (scAddr,':MEASURE:VMIN?',Status);
  Enter (r, 255, l, scAddr, Status);
  Val (r, VMin, Code);
end;


{
**************************************************************************
}

Procedure MessbereichEinstellen(ch: integer);
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am 30.11.06 von Uwe Weidlich
was  : alles
       Komlett neu programmiert. Die Einstellung erfolgt wesentlich
       schneller und genauer.
SPG_ANPASS
Abfrage ob Vmax vorhanden ist, wenn nicht Range erhîhen.
Folgender Merker wird gesetzt:
   merker7 : boolean
***********************************}
const Over:Single = 50.0;
      Range_min:Single = 16E-3;
      Range_max:Single = 40.0;
var
   code    : integer;
   status  : integer;
   r       : string;
   l       : word;
   adr_str : string;
   ch_str  : string;
   UMin, UMax: Single;
   Range_Neu, Range: Single;
   ok:Boolean;
   RangeStr_alt, RangeStr_neu: String;

begin
  merker7:=false;
  str (ch,ch_str);
  Repeat
    {*} ABBRUCH;
    ok:=TRUE;
    scMinMaxLesen(adr_os, ch, UMin, UMax);

    { bisherigen y-Bereich als String sichern }
    send (adr_os,':CHANNEL'+ch_str+':RANGE?',status);
    enter (RangeStr_alt,255,l,adr_os,status);

    { öberprÅfung auf BereichsÅberschreitung }
    if (Abs(UMax) >= OVER) OR (Abs(UMin) >= OVER) then
    begin { wenn BereichsÅberschreitung }
      { aktuelle Einstellung einlesen }
      send (adr_os,':CHANNEL'+ch_str+':RANGE?',status);
      enter (r,255,l,adr_os,status);
      val (r,Range,code);
      Range_neu:=2*Range;
      if Range_neu > Range_max then Range_neu:=Range_max;
      Str(Range_neu, info_str);
      send (adr_os,':CHANNEL'+ch_str+':RANGE '+info_str+' V',status);
      ok:=FALSE;
    end;

    { öberprÅfung, ob ein kleinerer Bereich eingestellt werden kann }
    if (Abs(UMax) < OVER) AND (Abs(UMin) < OVER) then
    begin { wenn bisher keine BereichsÅberschreitung }
      { aktuelle Einstellung einlesen }
      send (adr_os,':CHANNEL'+ch_str+':RANGE?',status);
      enter (r,255,l,adr_os,status);
      val (r,Range,code);
      if Abs(UMax) > Abs(UMin)
      then Range_Neu:=2.2*Abs(UMax)
      else Range_Neu:=2.2*Abs(UMin);
      if Range_Neu > Range_max then Range_Neu:=Range_max;
      if Range_Neu < Range_min then Range_Neu:=Range_min;
      if Range_neu/Range < 0.90 then
      begin { neue Einstellung ist relevant }
        str (Range_Neu:6:3,info_str);
        send (adr_os,':CHANNEL'+ch_str+':RANGE '+info_str+' V',status);
        ok:=FALSE;
      end;
    end;
    Delay(500);
    { neuen y-Bereich als String einlesen }
    send (adr_os,':CHANNEL'+ch_str+':RANGE?',status);
    enter (RangeStr_neu,255,l,adr_os,status);

    { Ende, wenn keine énderung des Bereichs erfolgt ist }
    if RangeStr_alt = RangeStr_neu then ok:=TRUE;
  until ok;

  merker7:=TRUE;

  {*} ABBRUCH;
end; { ENDE MessbereichEinstellen }
{
**************************************************************************
}
Procedure ANPASSUNG       ( add     : single;
                            var spg : single);
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am 23.02.98 von U.Weidlich
was  : Beschreibung korrigiert
geÑn.: am 09.06.98 von U.Weidlich
was  : Aufruf von ABBRUCH nicht innerhalb einer reinen Berechnungsschleife
geÑn.: am 15.06.1998 von U.Weidlich
was  : Spannung wird als Festkommazahl an den Funktionsgenerator Åbertragen

ANPASSUNG:
Kanalinformationen einholen.
Spannung messen die proportional zur Flussdichte ist.
Integrieren der Spannungsme·werte.
Symmetrieren der Messwerte.
Folgende Merker werden gesetzt:
   merker1  : boolean
   merker9  : boolean
***********************************}
var
   d        : daten;           { Blockdaten }
   i        : integer;         { Laufindex }
   punkte, punkte1, punkte2   : LongInt;
   DeltaT   : single;
   bausgl   : single;
   r        : string;
   l        : word;

begin
  New ( Umess );
  New ( BMess );
  New ( HMess );

  repeat

  {*} ABBRUCH;
  spg:=Int(1000*spg)/1000;
  if spg >= max_spg_fg then

  begin
    merker1:=true;
    Exit;
  end;

  spg:=spg + add;
  if spg < min_spg_fg then spg:=min_spg_fg;

  fgSpannungEinstellen(spg);
  Delay(1000);

  {*} MessbereichEinstellen(1);
  send (adr_os,':DIGITIZE CHANNEL1',status);
  Delay(500);
  {*} ABBRUCH;
  send (adr_os,'*OPC?',status);
  repeat

  Delay(100);
  enter(r,255,l,adr_os,status);
  val (r,weiter,code);

  until weiter = 1;

  send (adr_os,':WAVEFORM:SOURCE CHANNEL1',status);
  {*}  KANAL_INFO (yin,yor,yre,xin);
  deltaT:=xin;
  send (adr_os,':WAVEFORM:POINTS?',status);
  enter (r,255,l,adr_os,status);
  val (r,punkte,code);
  send (adr_os,':WAVEFORM:DATA?',status);
  str (adr_os,adr_str);
  transmit (' MLA TALK '+adr_str,status);
  rarray (d,count,l,status);
  transmit (' UNT LISTEN '+adr_str,status);
  transmit (' MTA ',status);
  send (adr_os,':RUN',status);

  {$IFDEF DSO5012A}
    send (adr_os,':DISPLAY:CLEAR',status);
  {$ELSE}
    send (adr_os,':DISPLAY:TEXT BLANK',status);
  {$ENDIF}

  {*} ABBRUCH;
  for i:=1 to punkte do

  begin
    Umess^[i]:=((d.dat[i]-yre)*yin)+yor;
  end;
  {*} ABBRUCH;
  {*} RUNGE_KUTTA_2(Punkte,DeltaT,UMess,faktor1,Bmess);

  punkte1:=punkte;
  MessbereichEinstellen(2);
  send (adr_os,':WAVEFORM:SOURCE CHANNEL2',status);
  send (adr_os,':WAVEFORM:POINTS?',status);
  enter (r,255,l,adr_os,status);
  val (r,punkte2,code);
  if punkte1 <> punkte2 then

  begin
    Writeln(' Zeitbasisverschiebung, Messung mu· abgebrochen werden !!! ');
    Writeln(' Oszi und Freq.gen wurden entriegelt ');
    send (adr_os,':SYSTEM:LOCK OFF',status);
    str (adr_fg,adr_str);
    transmit ('GTL'+adr_str,status);
    Halt(2);
  end;

  punkte:=punkte1;
  {*}KANAL_INFO ( yin,yor,yre,xin );
  send (adr_os,':WAVEFORM:DATA?',status);
  str (adr_os,adr_str);
  transmit (' MLA TALK '+adr_str,status);
  rarray (d,count,l,status);
  transmit (' MTA LISTEN '+adr_str,status);
  hmax2:=-100;
  {*} ABBRUCH;
  for i:=1 to punkte do

  begin
    Hmess^[i]:=(((d.dat[i]-yre)*yin)+yor) * faktor2;
    if Hmess^[i] > hmax2 then

    begin
      hmax2 := Hmess^[i];
      i1:=i;
    end;

  end;

  {*} KURVE_SYM ( BMess,punkte,bmax1,bmin1);

  {*} KURVE_SYM ( HMess,punkte,hmax1,hmin1 );

  {*} ABBRUCH;
  if spg < 2 then
  merker9:=true;
  if spg >= 2 then
  merker9:=false;

  until bmax1 > b_gew;

  Dispose ( UMess );
  Dispose ( BMess );
  Dispose ( HMess );
  {*} ABBRUCH;
end; { ENDE ANPASSUNG }
{
**************************************************************************
}
Procedure FLUSSDICHTE_ANPASS;
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
FLUSSDICHTE_ANPASS:
Spannung schrittweise erhîhen:
Spannungsschritte 2V , 1V , 0.5V , 0.1V , 0.02V.
Abbrechen wenn die maximale Spannung erreicht wird.
Abbrechen wenn die minimale Spannung erreicht wird.
Abbrechen wenn die gewÅnschte Spannung erreicht ist.
***********************************}
var
   add     : single;
   spg     : single;

begin
  {*} ABBRUCH;
  {$IFDEF DSO5012A}
    send (adr_os,':ACQUIRE:TYPE HRESOLUTION',status);
  {$ELSE}
    send (adr_os,':ACQUIRE:TYPE NORMAL',status);
  {$ENDIF}
  send (adr_os,':CHANNEL1:RANGE 40 V',status);
  send (adr_os,':CHANNEL2:RANGE 8 V',status);
  bmax1:=0;
  add:=2;
  spg:=0;
  {*} ANPASSUNG (add,spg);

  if merker1 = true then

  begin
    b_gew:=bmax1;
    spg_abw:=spg;

    {$IFDEF DSO5012A}
      send (adr_os,':DISPLAY:CLEAR',status);
    {$ELSE}
      send (adr_os,':DISPLAY:TEXT BLANK',status);
    {$ENDIF}

    Exit
  end;

  add:=1;
  spg:=spg - 2;
  {*} ANPASSUNG (add,spg);
  {*} ABBRUCH;

  if merker1 = true then

  begin
    b_gew:=bmax1;
    spg_abw:=spg;

    {$IFDEF DSO5012A}
      send (adr_os,':DISPLAY:CLEAR',status);
    {$ELSE}
      send (adr_os,':DISPLAY:TEXT BLANK',status);
    {$ENDIF}

    Exit
  end;

  add:=0.5;
  spg:=spg - 1;
  {*} ANPASSUNG (add,spg);
  {*} ABBRUCH;

  if merker1 = true then

  begin
    b_gew:=bmax1;
    spg_abw:=spg;

    {$IFDEF DSO5012A}
      send (adr_os,':DISPLAY:CLEAR',status);
    {$ELSE}
      send (adr_os,':DISPLAY:TEXT BLANK',status);
    {$ENDIF}

    Exit
  end;

  add:=0.1;
  spg:=spg - 0.5;
  {*} ANPASSUNG (add,spg);
  {*} ABBRUCH;

  if merker1 = true then

  begin
    b_gew:=bmax1;
    spg_abw:=spg;

    {$IFDEF DSO5012A}
      send (adr_os,':DISPLAY:CLEAR',status);
    {$ELSE}
      send (adr_os,':DISPLAY:TEXT BLANK',status);
    {$ENDIF}

    Exit
  end;

  if spg < min_spg_fg then

  begin
    spg_abw:=spg;

    {$IFDEF DSO5012A}
      send (adr_os,':DISPLAY:CLEAR',status);
    {$ELSE}
      send (adr_os,':DISPLAY:TEXT BLANK',status);
    {$ENDIF}

    Exit;
  end;

  add:=0.05;
  spg:=spg - 0.1;
  {*} ANPASSUNG (add,spg);
  {*} ABBRUCH;

  if merker1 = true then

  begin
    spg_abw:=spg;

    {$IFDEF DSO5012A}
      send (adr_os,':DISPLAY:CLEAR',status);
    {$ELSE}
      send (adr_os,':DISPLAY:TEXT BLANK',status);
    {$ENDIF}

    Exit;
  end;

  if spg < min_spg_fg then

  begin
    spg_abw:=spg;

    {$IFDEF DSO5012A}
      send (adr_os,':DISPLAY:CLEAR',status);
    {$ELSE}
      send (adr_os,':DISPLAY:TEXT BLANK',status);
    {$ENDIF}

    Exit;
  end;

  add:=0.02;
  spg:=spg - 0.05;
  {*} ANPASSUNG (add,spg);
  {*} ABBRUCH;

  if merker1 = true then

  begin
    spg_abw:=spg;

    {$IFDEF DSO5012A}
      send (adr_os,':DISPLAY:CLEAR',status);
    {$ELSE}
      send (adr_os,':DISPLAY:TEXT BLANK',status);
    {$ENDIF}

    Exit;
  end;

  spg_abw:=spg;
  {*} ABBRUCH;
end;  { ENDE FLUSSDICHTE_ANPASS }
{
**************************************************************************
}
Procedure PRUEF_ANPASS;
{***********************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
öberprÅfen ob die minimale Messpannung unterschritten wurde.
Folgender Merker wird gesetzt:
   merker8  : boolean
***********************************}

var
  spg : single;

begin
  if spg_abw <= min_spg_fg then

  begin
    spg_abw:=min_spg_fg;
    spg:=min_spg_fg;
    fgSpannungEinstellen(spg);
    Delay(1000);

    merker8:=true;
  end;

  {*} ABBRUCH;

end;  { ENDE PRUEF_ANPASS }

Procedure fgSpannungEinstellen(U:Single);
begin

  {$IFDEF HP8116A}
  { Werte fÅr den Funktionsgenerator HP8116A }
    str (U:7:4,info_str);
    send (adr_fg,'AMP '+info_str+' V',status);
  {$ENDIF}

  {$IFDEF HP33120A}
  { Werte fÅr den Funktionsgenerator HP33120A }
    str (U:7:4,info_str);
    send (adr_fg,'VOLTAGE '+info_str,status);
  {$ENDIF}

  {$IFDEF AGT33220A}
  { Werte fÅr den Funktionsgenerator Agilent 33220A }
    str (U:7:4,info_str);
    send (adr_fg,'VOLTAGE '+info_str,status);
  {$ENDIF}

  {$IFDEF HP33250A}
  { Werte fÅr den Funktionsgenerator Agilent/HP 33250A }
    str (U:7:4,info_str);
    send (adr_fg,'VOLTAGE '+info_str,status);
  {$ENDIF}

  {$IFDEF PM5138}
  { Werte fÅr den Funktionsgenerator PM5318/PM5139 }
  { AMLITUDE steht hier fÅr Uss }
    str (2*U:7:4,info_str);
    send (adr_fg,'AMPLT '+info_str,status);
  {$ENDIF}

end;

Procedure fgFrequenzEinstellen(Frequenz:Single);
var info_str:String;
begin

  {$IFDEF HP8116A}
  { Werte fÅr den Funktionsgenerator HP8116A }
    str (freq,info_str);
    send (adr_fg,'FRQ '+info_str+' HZ',status);
    { Frequenz die einzustellen ist am Frequenzgenerator }
    send (adr_fg,'D0',status);
    Delay(1000);
  {$ENDIF}

  {$IFDEF HP33120A}
  { Werte fÅr den Funktionsgenerator HP 33120A }
    str (freq:7,info_str);
    send (adr_fg,'FREQUENCY '+info_str,status);
    Delay(1000);
  {$ENDIF}

  {$IFDEF AGT33220A}
  { Werte fÅr den Funktionsgenerator Agilent 33220A }
    str (freq:7,info_str);
    send (adr_fg,'FREQUENCY '+info_str,status);
    Delay(1000);
  {$ENDIF}

  {$IFDEF HP33250A}
  { Werte fÅr den Funktionsgenerator Agilent/HP 33250A }
    str (freq:7,info_str);
    send (adr_fg,'FREQUENCY '+info_str,status);
    Delay(1000);
  {$ENDIF}

  {$IFDEF PM5138}
  { Werte fÅr den Funktionsgenerator PM5318/PM5139 }
    str (freq:7,info_str);
    send (adr_fg,'FREQ '+info_str,status);
    Delay(1000);
  {$ENDIF}

end; {Procedure fgFrequenzEinstellen}

Procedure fgInitialisieren;
begin

  {$IFDEF HP8116A}
  { Werte fÅr den Funktionsgenerator HP8116A }
    send (adr_fg,'EST,D1,M1,CT0,T0',status);
    send (adr_fg,'H0,W1,DTY 50%,OFS 0V',status);
    send (adr_fg,'L0,C0,A0,AMP 0.1 V',status);
    send (adr_fg,'D0',status);
    Delay(1000);
  {$ENDIF}

  {$IFDEF HP33120A}
  { Werte fÅr den Funktionsgenerator HP 33120A }
    send (adr_fg,'*RST',status);
    Delay(1000);
    send (adr_fg,'APPLY:SIN 50,MIN,0.0',status);
    { Sinus, 50Hz, Amplitude: MIN=50mV, Offset: MIN=0V }
    send (adr_fg,'OUTPUT:SYNC ON',status);
    { Sync-Ausgang zur externen Triggerung des Oszilloskops freigeben }
    Delay(1000);
  {$ENDIF}

  {$IFDEF AGT33220A}
  { Werte fÅr den Funktionsgenerator HP/Agilent 33220A }
    send (adr_fg,'*RST',status);
    Delay(1000);
    send (adr_fg,'APPLY:SIN 50,MIN,0.0',status);
    { Sinus, 50Hz, Amplitude: MIN=1mV, Offset: 0V }
    send (adr_fg,':OUTPUT:SYNC ON',status);
    { Sync-Ausgang zur externen Triggerung des Oszilloskops freigeben }
    send (adr_fg,':OUTPUT ON',status);
    { Ausgang freigeben }
    Delay(1000);
  {$ENDIF}

  {$IFDEF HP33250A}
  { Werte fÅr den Funktionsgenerator HP/Agilent 33250A }
    send (adr_fg,'*RST',status);
    Delay(1000);
    send (adr_fg,'APPLY:SIN 50,MIN,0.0',status);
    { Sinus, 50Hz, Amplitude: MIN=1mV, Offset: 0V }
    send (adr_fg,':OUTPUT:SYNC ON',status);
    { Sync-Ausgang zur externen Triggerung des Oszilloskops freigeben }
    send (adr_fg,':OUTPUT ON',status);
    { Ausgang freigeben }
    Delay(1000);
  {$ENDIF}

  {$IFDEF PM5138}
  { Werte fÅr den Funktionsgenerator PM5318/PM5139 }
    Writeln('Funktionsgenerator wird initialisiert');
    send (adr_fg,'*RST',status);
    { Die Initialisierung beim PM5138 dauert sehr lang. In dieser Zeit dÅrfen
      keine weiteren Befehle gesendet werden }
    Delay(5000);
    fgSpannungEinstellen(0.1);
    Delay(1000);
  {$ENDIF}
end; {Procedure fgInitialisieren}

{
**************************************************************************
}
begin
end.