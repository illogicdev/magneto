Unit MESSUNG;

Interface

Uses VARDEF,IEEEPAS,GERAETE,MATHE,MELDUNG,CRT,UW;
{
*********************************************************************
}
Procedure MESSUNG_HYS;
Procedure ENT_MAGNET;
Procedure MESSUNG_KOM;
Procedure SPEICHER;
{
*********************************************************************
*********************************************************************
}
Implementation

var
   i,ii         : integer;
   punkte1      : word;
   punkte2      : word;
   code         : integer;
   status       : integer;
   adr_str      : string;
   r            : string;
   l            : word;
   info_str     : string;
   hys_ver_s    : string;

{
*********************************************************************
}
Procedure HystereseschleifeMessen;
begin
end;
{
*********************************************************************
}

Procedure FlussdichteEinstellen;
begin
  HystereseschleifeMessen;
end;

{
*********************************************************************
}
Procedure KommutierungskurveMessen;
begin
  HystereseschleifeMessen;
end;

{
*********************************************************************
}
Procedure MESSUNG_HYS;
{***********************************
erst.: am 22.11.94 von M.Schweizer
ge„n.: am 19.02.1998 von U. Weidlich
was  : Aufruf von "KURVE_SYM" nach der "Korrektur der Hys-Kurve" statt vorher.
       am 28.01.99 von U. Weidlich
       Triggerung des Oszilloskops wird bei den Grundeinstellungen  (UNIT Geraete)
       eingestellt
       Umstellung auf externe Triggerung (wg. Probleme mit der Mittelwertbildung
       bei kleinen Eingangsspannungen)

MESSUNG_HYS:
Aufnehmen der Meáwerte der Hystereseschleife.
   hys_ver    : single;     Verlustleistung berechnen
Korrektur der Hystereseschleife, ( Rampenfunktion ).
Speichern der Meáwerte der Hystereseschleife.
***********************************}
var
   antwort      : word;
   spg          : double;
   hys          : text;
   b_kor        : single;
   spg_zw       : single;

begin
  {*} ABBRUCH;
  New ( UMess );
  New ( HMess );
  New ( BMess );
  send (adr_os,':VIEW CHANNEL1',status);
  send (adr_os,':VIEW CHANNEL2',status);
  send (adr_os,':CHANNEL2:RANGE 8V',status);
  delay (500);
  {*} MessbereichEinstellen(2);
  send (adr_os,':ACQUIRE:TYPE AVERAGE',status);
  send (adr_os,':ACQUIRE:COUNT 64',status);
  send (adr_os,':DIGITIZE CHANNEL1, CHANNEL2',status);
  {*} ABBRUCH;
  send (adr_os,'*OPC?',status);

  repeat
    enter(r,255,l,adr_os,status);
    val (r,weiter,code);
    Delay(100);
  until weiter = 1;

  send (adr_os,':WAVEFORM:SOURCE CHANNEL1',status);
  send (adr_os,':WAVEFORM:POINTS?',status);
  enter (r,255,l,adr_os,status);
  val (r,punkte,code);
  punkte1:=punkte;
  {*}KANAL_INFO ( yin,yor,yre,xin );
  DeltaT:=xin;
  send (adr_os,':WAVEFORM:DATA?',status);
  str (adr_os,adr_str);
  transmit (' MLA TALK '+adr_str,status);
  rarray (d,count,l,status);
  transmit (' MTA LISTEN '+adr_str,status);
  {*} ABBRUCH;
  for i:=1 to punkte1 do

  begin
    Umess^[i]:=((d.dat[i]-yre)*yin)+yor;
  end;

  {*}RUNGE_KUTTA_2 ( Punkte1,DeltaT,UMess,faktor1,Bmess );

  b_gew:=bmax1;

  punkte:=trunc (punkte/merker_freq);

  if freq > 500 then
  begin
    pu_gr_500:=punkte;
  end;

  send (adr_os,':WAVEFORM:SOURCE CHANNEL2',status);
  send (adr_os,':WAVEFORM:POINTS?',status);
  enter (r,255,l,adr_os,status);
  val (r,punkte2,code);

  if punkte1 <> punkte2 then

  begin
    Writeln(' Zeitbasisverschiebung, Messung muá abgebrochen werden !!! ');
    Writeln(' Oszi und Freq.gen wurden entriegelt ');
    send (adr_os,':SYSTEM:LOCK OFF',status);
    str (adr_fg,adr_str);
    transmit ('GTL'+adr_str,status);
    Halt(2);
  end;

  {*}KANAL_INFO ( yin,yor,yre,xin );
  send (adr_os,':WAVEFORM:DATA?',status);
  str (adr_os,adr_str);
  transmit (' MLA TALK '+adr_str,status);
  rarray (d,count,l,status);
  transmit (' MTA LISTEN '+adr_str,status);
  hmax1:=-100;
  hmin1:=+100;
  {*} ABBRUCH;

  for i:=1 to punkte do
  begin
    HMess^[i]:=(((d.dat[i]-yre)*yin)+yor) * faktor2; { Einheit:A/m }
    if Hmess^[i] > hmax1 then
    hmax1:=Hmess^[i];
    if Hmess^[i] < hmin1 then
    hmin1:=Hmess^[i];
  end;

  {* Korrektur der Hys-Kurve *}
  b_kor:= ( BMess^[1] - BMess^[punkte] ) / punkte;
  {*} ABBRUCH;
  for i:=1 to ( punkte ) do

  begin
    BMess^[i+1]:= BMess^[i+1] + ( b_kor * i );
  end;

  {*} KURVE_SYM ( BMess,punkte,bmax1,bmin1 );

  {*} KURVE_SYM ( HMess,punkte,hmax1,hmin1 );

  {>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

    MesswerteSichern(Punkte, UMess, HMess, faktor2, DeltaT,
                           text_pr,
                           n1, n2,
                           a, lm, dichte,
                           Verstaerkung, spgteiler, Shunt, spg,
                           freq,
                           messnr);


  {<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<}

  {* Verluste berechnen *}
  hys_ver:=0;
  for i:=1 to punkte-1 do

  begin
    hys_ver:=hys_ver + ( HMess^[i] - HMess^[i+1] ) * (( BMess^[i] + BMess^[i+1] ) / 2 );
  end;
  hys_ver:=( hys_ver * freq )/( Dichte * 1000 );
  { hys_ver umwandeln in string hys_ver_s }
  str (hys_ver,hys_ver_s);
  { Numerisch messnr umwandeln in string messnr_s }
  str(messnr,messnr_s);
  assign ( hys,messnr_s+'hys.dat');
  rewrite ( hys );
  {*} ABBRUCH;
  for i:=1 to punkte do

  begin
    writeln ( hys,Hmess^[i],' ',BMess^[i] );
  end;

  writeln ( hys,Hmess^[1],' ',BMess^[1] );
  close ( hys );
  {*}BR_WERT ( HMess,BMess,punkte,Br );
  {*}HC_WERT ( HMess,BMess,punkte,Hc );
  Dispose ( UMess );
  Dispose ( HMess );
  Dispose ( BMess );
  send (adr_os,':RUN',status);
  {*} ABBRUCH;
end; { ENDE MESSUNG_HYS }
{
**************************************************************************
}
Procedure ENT_MAGNET;
{***********************************
erst.: am 22.11.94 von M.Schweizer
ge„n.: am 15.06.1998 von U.Weidlich
was  : Abbruchbedingung der REPEAT-UNTIL-Schleife ge„ndert
       Spannung wird als Festkommazahl an den Funktionsgenerator bertragen
ENT_MAGNET:
Entmagnetisieren der Meáeinrichtung
***********************************}
var
   spg      : single;
   info_str : string;

begin
  {*} ABBRUCH;

  {$IFDEF DSO5012A}
    send (adr_os,':ACQUIRE:TYPE HRESOLUTION',status);
  {$ELSE}
    send (adr_os,':ACQUIRE:TYPE NORMAL',status);
  {$ENDIF}

  spg:=spg_abw;

  repeat
  spg:=spg - 0.2;

  { Sicherheitsabfrage wegen HP 33120A }
  if spg < min_spg_fg then spg:=min_spg_fg;
  fgSpannungEinstellen(spg);
  delay(250);

  {*}ABBRUCH;

  until spg <= 1.001*min_spg_fg;

  { fgSpannungEinstellen(0.05); }

end; { ENDE ENT_MAGNET }
{
**************************************************************************
}
Procedure MESSUNG_KOM;
{***********************************
Messung der Kommutierungskurve.
H”chste Spanung aus der Messung der Hystereseschleife in spg_abw.
erst.: am 22.11.94 von M.Schweizer
ge„n.: am 23.02.1998 von U. Weidlich
was  : "Korrektur der Hys-Kurve" vor Aufruf von "KURVE_SYM" eingefgt.
       am 28.01.99 von U. Weidlich
       Triggerung des Oszilloskops wird bei den Grundeinstellungen  (UNIT Geraete)
       eingestellt
       Umstellung auf externe Triggerung (wg. Probleme mit der Mittelwertbildung
       bei kleinen Eingangsspannungen)
MESSUNG2:
Aufnehmen und Speichern der Meáwerte der Kommutierungskurve.
***********************************}
var
   add          : single;
   spg2         : single;
   spg1         : single;
   spg_zw       : extended;
   kom          : text;
   i            : integer;
   b_kor        : single;

begin
  {*} ABBRUCH;
  New ( UMess );
  New ( HMess );
  New ( BMess );
  New ( KHMess );
  New ( KBMess );
  { Schrittweite der Messungen kom an
  die Spannungsdifferenz anpassen }
  if spg_abw < 4 then
  add:=(spg_abw-0.1)/15;
  if spg_abw < 8 then
  add:=(spg_abw-0.1)/20;
  if spg_abw >= 8 then
  add:=(spg_abw-0.1)/25;

  {$IFDEF DSO5012A}
    send (adr_os,':ACQUIRE:TYPE HRESOLUTION',status);
  {$ELSE}
    send (adr_os,':ACQUIRE:TYPE NORMAL',status);
  {$ENDIF}
  send (adr_os,':CHANNEL2:RANGE 8 V',status);
  send (adr_os,':CHANNEL1:RANGE 40 V',status);

  spg2:=0.1;
  ii:=1;

  while spg2 < 1.0001*spg_abw do
  begin
    { Wenn eine neue Spannung eingestellt wird kein Average }
    {$IFDEF DSO5012A}
      send (adr_os,':ACQUIRE:TYPE HRESOLUTION',status);
    {$ELSE}
      send (adr_os,':ACQUIRE:TYPE NORMAL',status);
    {$ENDIF}

    { Sicherheitsabfrage wegen Rundungsfehler }
    if spg2 > max_spg_fg then spg2:=max_spg_fg;
    fgSpannungEinstellen(spg2);
    delay(1000);
    {*} MessbereichEinstellen(1);
    {*} MessbereichEinstellen(2);
    delay (500);
    send (adr_os,':ACQUIRE:TYPE AVERAGE',status);
    send (adr_os,':ACQUIRE:COUNT 8',status);

    send (adr_os,':DIGITIZE CHANNEL1, CHANNEL2',status);
    {*} ABBRUCH;
    send (adr_os,'*OPC?',status);

    repeat
      enter(r,255,l,adr_os,status);
      val (r,weiter,code);
    until weiter = 1;

    send (adr_os,':WAVEFORM:SOURCE CHANNEL1',status);
    send (adr_os,':WAVEFORM:POINTS?',status);
    enter (r,255,l,adr_os,status);
    val (r,punkte1,code);
    {*}KANAL_INFO ( yin,yor,yre,xin );
    DeltaT:=xin;
    send (adr_os,':WAVEFORM:DATA?',status);
    str (adr_os,adr_str);
    transmit (' MLA TALK '+adr_str,status);
    rarray (d,count,l,status);
    transmit (' MTA LISTEN '+adr_str,status);
    {*} ABBRUCH;
    for i:=1 to punkte1 do

    begin
      Umess^[i]:=((d.dat[i]-yre)*yin)+yor;
    end;

    {*}RUNGE_KUTTA_2 ( Punkte1,DeltaT,UMess,faktor1,Bmess );

      if freq > 500 then
    begin
      punkte:= trunc (punkte/merker_freq);
      pu_gr_500:=punkte;
    end;

    send (adr_os,':WAVEFORM:SOURCE CHANNEL2',status);
    send (adr_os,':WAVEFORM:POINTS?',status);
    enter (r,255,l,adr_os,status);
    val (r,punkte2,code);
    if punkte1 <> punkte2 then

    begin
      Writeln(' Zeitbasisverschiebung, Messung muá abgebrochen werden !!! ');
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

    {* Korrektur der Hys-Kurve *}
    b_kor:= ( BMess^[1] - BMess^[punkte] ) / punkte;
    {*} ABBRUCH;
    for i:=1 to ( punkte ) do

    begin
      BMess^[i+1]:= BMess^[i+1] + ( b_kor * i );
    end;

    {*} KURVE_SYM ( BMess,punkte,bmax2,bmin2 );

    {*} KURVE_SYM ( HMess,punkte,hmax1,hmin1 );

    {*}ABBRUCH;
    begin
      { SPEICHERN WERTE KOMMUTIERUNGSKURVE }
      KHMess^[ii]:=hmax2;
      KBMess^[ii]:=bmax2;
    end;

    ii:=ii+1;
    send (adr_os,':RUN',status);
    spg2:=spg2+add;
  end; {While }

  begin

    { DATEI MIT WERTE KOMMUTIERUNGSKURVE }
    assign ( kom,messnr_s+'kom.dat');
    rewrite ( kom );
    for i:=1 to (ii-1) do

    begin
      writeln ( kom,KHMess^[i],' ',KBMess^[i]);
    end;

    close ( kom );
    Dispose ( KHMess );
    Dispose ( KBMess );
    Dispose ( HMess );
    Dispose ( BMess );
    Dispose ( UMess );
  end;

  {*} ABBRUCH;

end; { ENDE MESSUNG_KOM }
{
**************************************************************************
}
Procedure SPEICHER;
{**************************************************
erst.: am 22.11.94 von M.Schweizer
ge„n.: am 24.02.95 von U. Weidlich
was  : 2 Nachkommastellen fr die Dichte werden ausgegeben
ge„n.: am 24.01.2008 von U. Weidlich
was  : 1 Nachkommastelle fr den Messwiderstand wird ausgegeben
SPEICHER:
Speichern der Meáwerte der sonstigen Information.
**************************************************}
var
   was  : text;

begin
  {*}ABBRUCH;
  { Bezugsdaten einlesen }
  assign (was,messnr_s+'was.dat');
  rewrite ( was );
  { Maximalwert der Hystereseschleife }
  writeln ( was,bmax1 );
  { Maximalwert der Hystereseschleife }
  writeln ( was,hmax1 );
  { Anzahl der Meápunkte }
  writeln ( was,punkte:4 );
  { Probenbezeichnung }
  writeln ( was,text_pr);
  { mittlere Eisenl„nge }
  writeln ( was,lm:6:1,' cm mittlere L„nge');
  { Eisenquerschnitt }
  writeln ( was,a:6:1,' mm^2 Probenquerschnitt');
  { Dichte des Eisens }
  writeln ( was,Dichte:5:2,' g/cm^3 Probendichte');
  { Prim„rwindungszahl }
  writeln ( was,n1:4:0,' Prim„rwindungen');
  { Sekund„rwindungszahl }
  writeln ( was,n2:4:0,' Sekund„rwindungen');
  { theoretische Sekund„rwindungszahl }
  writeln ( was,n2theo:6:1,' theo Sekund„rwind');
  { Spannungsteilerverh„ltnis }
  writeln ( was,'1:',spgteiler:4:1,' Spg-teilerverh');
  { Meáwiderstand }
  writeln ( was,shunt:5:1,' Ohm Messwiderstand');
  { gew„hlte Fluádichte }
  writeln ( was,b_gew:5:3,' T erreicht');
  { Frequenz }
  writeln ( was,freq:5);
  { gewnschte Fluádichte }
  writeln ( was,b_gewu:5:3,' T');
  { Koerzitivfeldst„rke }
  writeln ( was,Hc,' A/m Koerzitivfeldst„rke');
  { Remanenz }
  writeln ( was,Br,' T Remanenz');
  { Hystereseverluste }
  writeln ( was,hys_ver_s);
  { Meáz„hler }
  writeln ( was,messnr:3,'.Messung');
  { Punkte freq > 500 Hz }
  writeln ( was,pu_gr_500 );
  close ( was );
  {*} ABBRUCH;
end; { ENDE SPEICHER }
{
**************************************************************************
}
begin
end. { Unit MESSUNG }