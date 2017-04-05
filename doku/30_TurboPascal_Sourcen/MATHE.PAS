{$B+}
Unit Mathe;

Interface

Uses VarDef;

{
***************************************************************************
}
Procedure RUNGE_KUTTA_2 ( Punkte   :LongInt;
                          DeltaT   :Single;
                          u        :Wertefeld_Zeiger1;
                          faktor1  :single;
                          var B    :Wertefeld_Zeiger1);

Procedure KURVE_SYM     ( var   x_zg : Wertefeld_Zeiger1;
                          punkte     : LongInt;
                          var   xmax : single;
                          var   xmin : single);

Procedure BR_WERT       ( HMess   : Wertefeld_Zeiger1;
                          BMess   : Wertefeld_Zeiger1;
                          punkte  : LongInt;
                          var Br  : single);

Procedure HC_WERT       ( HMess   : Wertefeld_Zeiger1;
                          BMess   : Wertefeld_Zeiger1;
                          punkte  : LongInt;
                          var Hc  : single);

{
***************************************************************************
*
* Numerische Lîsung der Differentialgleichung B'=f(DeltaT, u)
* mit dem Runge-Kutta-Verfahren 2. Ordnung
*
* vorausgesetzte Vereinbarungen in Unit VarDef:
*
*   Konstanten:
*
*     MaxWerte = maximale Anzahl Me·werte fÅr Felddimensionierung
*
* Typen:
*
*     Wertefeld = Array[1..MaxWerte] of Single
*
*   Punkte:LongInt         Anzahl der Messpunke
*   DeltaT:Single          Schrittweite
*   u:Wertefeld_Zeiger1    Zeiger auf Spannungsmesswerte
*   B0:Single              Anfangsbedingung B(1)
*
* Ausgabeparameter:
*
*   B:Wertefeld_Zeiger1    Zeiger auf Funktionswerte B=f(u)
*
***************************************************************************
***************************************************************************
}
Implementation

Procedure Runge_Kutta_2( Punkte  :LongInt;
                         DeltaT  :Single;
                         u       :Wertefeld_Zeiger1;
                         faktor1 :single;
                         var B   :Wertefeld_Zeiger1);

var
   i   :Word;
   h_2 :Extended;  { halbe Schrittweite }

begin
  if Punkte < 50 then
  begin
    Writeln('Illegale Anzahl Werte (', Punkte , ') in Procedure Runge_Kutta_2');
    Halt(1);
  end;
  h_2:=DeltaT/2.0;
  B^[1]:=0;
  for i:=1 to Punkte-1 do B^[i+1]:=B^[i]+h_2*((u^[i]+u^[i+1])*faktor1);
end; {ENDE RUNGE_KUTTA_2}
{
**************************************************************************
}
Procedure KURVE_SYM       ( var   x_zg : Wertefeld_Zeiger1;
                            punkte     : LongInt;
                            var   xmax : single;
                            var   xmin : single);
{****************************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am
was  :
Symmetrieren der Kurve bezogen auf 'Null'
****************************************}
var
   xausgl  : single;
   i       : integer;

begin
  xmax:=-10000;                          { neusetzen der Parameter }
  xmin:=+10000;                          { neusetzen der Parameter }
  for i:=1 to punkte do
  begin
    if x_zg^[i] > xmax then xmax:=x_zg^[i];
    if x_zg^[i] < xmin then xmin:=x_zg^[i];
  end;

  xausgl:=(xmax + xmin)/2;

  xmax:= -10000;
  xmin:= +10000;
  for i:=1 to punkte do
  begin
    x_zg^[i]:=x_zg^[i] - xausgl;
    if x_zg^[i] > xmax then xmax:=x_zg^[i];
    if x_zg^[i] < xmin then xmin:=x_zg^[i];
  end;
end;  { ENDE KURVE_SYM }
{
**************************************************************************
}
Procedure BR_WERT           ( HMess   : Wertefeld_Zeiger1;
                              BMess   : Wertefeld_Zeiger1;
                              punkte  : LongInt;
                              var Br  : single);
{****************************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am 24.01.2008 von Uwe Weidlich
was  :
Bestimmung der Remanenzflu·dichte
(grî·ter B-Wert im 2. Quadrant)
*****************************************}
var
   i    : Integer;

begin
  Br:=-100;
  for i:=1 to punkte do
  if ( BMess^[i] >= 0 ) AND ( HMess^[i] < 0 ) then
  begin
    if BMess^[i] > Br then Br:=BMess^[i];
  end;
end; { ENDE BR_WERT }
{
**************************************************************************
}
Procedure HC_WERT           ( HMess   : Wertefeld_Zeiger1;
                              BMess   : Wertefeld_Zeiger1;
                              punkte  : LongInt;
                              var Hc  : single);
{****************************************
erst.: am 22.11.94 von M.Schweizer
geÑn.: am 24.01.2008 von Uwe Weidlich
was  :
Bestimmung der KoerzitivfeldstÑrke
(kleinster H-Wert im 2. Quadrant)
****************************************}
var
   i    : Integer;

begin
  Hc:=+10000;
  for i:=1 to punkte do
  if ( BMess^[i] >= 0 ) AND ( HMess^[i] <= 0 ) then
  begin
    if HMess^[i] < Hc then Hc:=HMess^[i];
  end;
end; { ENDE HC_WERT }
{
**************************************************************************
}
begin
end.