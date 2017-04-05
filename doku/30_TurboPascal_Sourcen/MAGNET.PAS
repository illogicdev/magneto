{$N+,E+}
program magnet;
{
erst.: am 22.11.94 von M.Schweizer
geÑn.: am 23.02.95 von U. Weidlich
was  : Exit Procedure des Programms wird bei regulÑrem Programmende
       nicht mehr aufgerufen
       Deklaration von ExitSave in Unit VARDEF
geÑn.: am 15.06.98 von U. Weidlich
was  : GTL beim Beenden des Programmes geÑndert
       (schnelleres Programmende, da kein ZeitÅberlauf mehr auftritt)
}

uses CRT,DOS,GERAETE,IEEEPAS,VARDEF,MELDUNG,MESSUNG,ANFANG,GRAFIK,GRAPH;

var
   status  : Integer;
   adr_str : String;

{$F+} Procedure MyExit; {$F-}

begin
  ExitProc:=ExitSave;
  send (adr_os,':SYSTEM:LOCK OFF',status);
  str (adr_fg,adr_str);
  transmit ('UNL LISTEN '+adr_str+' GTL',status);
  window(1,1,80,25);
  clrscr;
  writeln('Abbruch des Programmes durch control C ! ');
  writeln('Systeme entriegelt ! ');
end;
{
*********************************************************************
***************************Hauptprogramm*****************************
*********************************************************************
Folgende Merker werden gesetzt:
   merker1  : boolean
   merker4  : boolean
   merker5  : boolean
   merker8  : boolean
   merker10 : boolean
}
begin
  ExitSave:=ExitProc;
  ExitProc:=@MyExit;
  textbackground (black);
  textcolor (white);
  clrscr;
  SetCBreak(true);
  messnr:=1;
  merker1:=false;
  merker2:=false;
  merker3:=false;
  merker6:=false;
  merker8:=false;
  {*} INITIALISIER;
  {*} BEGRUESS;

  repeat

  merker10:=false;
  {*} EINGABE0;

  repeat

  merker4:=false;
  {*} EINGABE1;

  repeat

  merker5:=false;
  {*} EINGABE2;
  {*} OSZILLOSKOP_EINSTELLEN;
  {*} FREQ_EINST;
  {*} MELDUNG0;
  {*} BANDBREITE1;
  {*} MELDUNG1;
  {*} FLUSSDICHTE_ANPASS;
  {*} PRUEF_ANPASS;
  if merker1 = true then

  begin
    {*} MELDUNG2;
    merker1:= false;
    if merker2 = true then
    repeat
    window (1,1,79,25);
    clrscr;
    {*} MELDUNG21;
    {*} ENT_MAGNET;
    {*} EINGABE2;
    {*} OSZILLOSKOP_EINSTELLEN;
    {*} FREQ_EINST;
    {*} MELDUNG0;
    {*} BANDBREITE1;
    {*} MELDUNG1;
    {*} FLUSSDICHTE_ANPASS;
    {*} PRUEF_ANPASS;
    if merker1 = true then

    begin
      {*} MELDUNG2;
      merker1:=false;
    end;

    until merker2 = true;
    {*} MELDUNG3;
  end;

  if merker1 = false then

  begin
    {*} MELDUNG3;
  end;

  if merker8 = true then

  begin
    {*} MELDUNG31;
  end;

  {*} MELDUNG4;
  {*} MESSUNG_HYS;
  if merker8 = true then

  begin
    {*} MELDUNG32;
    merker8:=false;
  end;

  {*} BANDBREITE2;
  {*} MELDUNG5;
  {*} MELDUNG6;
  {*} ENT_MAGNET;
  {*} MELDUNG7;
  if merker9 = false then

  begin
    {*} MELDUNG8;
    if merker3 = false then

    begin
      {*} MELDUNG9;
      {*} BANDBREITE1;
      {*} MESSUNG_KOM;
      {*} MELDUNG10;
      {*} MELDUNG11;
      {*} ENT_MAGNET;
      {*} MELDUNG12;
      delay (2500);
    end;

  end;

  if merker9 = true then

  begin
    {*} MELDUNG81;
  end;

  {*} SPEICHER;
  {*} GRAFIK0;
  {*} GRAFIK1;
  if merker9 = false then

  begin
    if merker3 = false then

    begin
      {*} GRAFIK2;
    end;

  end;

  {*} GRAFIK3;
  if merker4 = true then

  begin
    {*} DRUCK;
    merker4:=false;
  end;

  CloseGraph;
  messnr:=messnr + 1;
  {*}MELDUNG0;
  {*}MELDUNG3;
  {*}MELDUNG5;
  {*}MELDUNG7;
  {*}MELDUNG82;
  if merker9 = false then

  begin
    if merker3 = false then

    begin
      {*}MELDUNG10;
      {*}MELDUNG12;
    end;

  end;

  {*}MELDUNG13;

  until merker5 = true;

  {*}MELDUNG14;

  until merker6 = true;

  {*}MELDUNG15;

  until merker10 = true;

  send (adr_os,':SYSTEM:LOCK OFF',status);
  str (adr_fg,adr_str);
  transmit ('UNL LISTEN '+adr_str+' GTL',status);
  window(1,1,78,24);
  clrscr;
  ExitProc:=ExitSave;
end.