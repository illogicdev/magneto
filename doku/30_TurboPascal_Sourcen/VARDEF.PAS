Unit VARDEF;
{
erst.: am 22.11.94 von M.Schweizer
ge„n.: am 23.02.98 von U.Weidlich
was  : Aufnahme von Variable ExitSave
ge„n.: am 06.09.2006 von U.Weidlich
was  : Bedingte Kompilierung fr weiteren Funktionsgenerator
}
Interface

const
     MaxWert1 = 4000;
     MaxWert2 = 100;

type
    Wertefeld1        = array[1..MaxWert1+1] of Single;
    Wertefeld_Zeiger1 = ^Wertefeld1;

    Wertefeld2        = array[1..MaxWert2+1] of Single;
    Wertefeld_Zeiger2 = ^Wertefeld2;

    {$IFDEF DSO5012A}
      daten            = record
           vordat  : array[1..10] of Byte;
           dat     : array[1..4000] of Word;
           enddat  : Byte;
           end;
    {$ELSE}
      daten            = record
           vordat  : array[1..10] of Byte;
           dat     : array[1..4000] of Byte;
           enddat  : Byte;
           end;
    {$ENDIF}

var
   UMess     : Wertefeld_Zeiger1;    { Gemessene Spannung der Fluádichte vor Integration }
   HMess     : Wertefeld_Zeiger1;    { magn. Fluádichte Werte }
   BMess     : Wertefeld_Zeiger1;    { Feldst„rke B Werte }
   KBMess    : Wertefeld_Zeiger2;    { Kommutierungskurve B Werte }
   KHMess    : Wertefeld_Zeiger2;    { Kommutierungskurve H Werte }

   freq       : longint;     { Ein_par : Frequenz }
   text_pr    : string;      { Ein_par : Textbezeichnung }
   b_gew      : single;      { gew„hlte Fluádichte }
   b_gewu     : single;      { Ein_par : gewnschte Fluádichte }
   dichte     : single;      { Ein_par : Dichte des Materials }
   n1         : single;      { Ein_par : Prim„rwindungszahl }
   n2         : single;      { Ein_par : Sekund„rwindungszahl }
   n2theo     : single;      { Ber_par : theoretische Sekund„rwindungszahl }
   lm         : single;      { Ein_par : Eisenwegl„nge }
   shunt      : single;      { Meáwiderstand }
   a          : single;      { Ein_par : Querschnitt des Eisens }
   spgteiler  : single;      { Ein_par : Spannungsteiler }
   bandbr     : double;      { errechnete Variable }

   pu_gr_500  : integer;     { Anz. der Punkte bei freq > 500 Hz }
   punkte     : LongInt;     { Anzahl der Meápunkte des Oszilloskop's }
   messnr     : integer;     { Anzahl der Messungen }
   messnr_s   : string;      { Anzahl der Messungen als String }
   d          : daten;       { Daten der Kan„le }

   faktor1    : double;      { Berechnet aus Eingabeparameter }
   faktor2    : double;      { Berechnet aus Eingabeparameter }

   merker1    : boolean;     { maximale Spannung erreicht ? }
   merker2    : boolean;     { weiter mit dem erreichten maximalen Wert J/N ?}
   merker3    : boolean;     { Neu- und Kommutierungskurve messen }
   merker4    : boolean;     { Druckermerker }
   merker5    : boolean;     { neue Frequenz und Fluádichtevorgabe }
   merker6    : boolean;     { neue Probenspezifikation }
   merker7    : boolean;     { Anpassung durchlaufen ? }
   merker8    : boolean;     { minimale Spannung erreicht }
   merker9    : boolean;     { spg < 2 keine Neu+Kom Messung }
   merker10   : boolean;     { Neue Messnummer eingeben ? }

   merker_freq: single;      { Teilerfaktor fr Punkte }

   weiter     : integer;     { Merker ob Funktion ausgefhrt ist }

   yor        : single;      { Kanalparameter Oszilloskop }
   yin        : single;      { Kanalparameter Oszilloskop }
   yre        : single;      { Kanalparameter Oszilloskop }
   xin        : single;      { Kanalparameter Oszilloskop }
   DeltaT     : single;      { Zeitschritt }

   br         : single;      { Remanenz }
   bmax1      : single;      { max Fluádichte Messung 1 }
   bmin1      : single;      { min Fluádichte Messung 1 }
   bmax2      : single;      { max Fluádichte Messung 2 }
   bmin2      : single;      { min Fluádichte Messung 2 }
   b_str      : string;      { string }

   hc         : single;      { Koerzitivfeldst„rke  }
   hmax1      : single;      { max magn. Feldst„rke Messung 1 }
   hmin1      : single;      { min magn. Feldst„rke Messung 1 }
   hmax2      : single;      { max magn. Feldst„rke Messung 2 }
   h_str      : string;      { string }

   hys_ver    : double;      { Verlustleistung }

   i1         : integer;     { fr Kommutierungskurve position NBMess }

   spg_max    : single;
   spg_abw    : single;      { Spannung die bei Anpassung erreicht wird }
   ExitSave   : Pointer;
{
**************************************************************************
}
const
   count:integer=10000;

   adr_pc    = 21;            { Adresse des PC's }
   adr_os    = 7;             { Adresse des Oszilloskops }
   Verstaerkung:Single = 1.0; { Verst„rkungsfaktor des Leistungsverst„rkers }

   {$IFDEF HP8116A}
   { Werte fr den Funktionsgenerator HP8116A }
   adr_fg    = 16;            { Adresse des Frequenzgen. }
   max_spg_fg= 16;            { max. Ausgangsspg. des Frequenzgen. }
   min_spg_fg= 0.1;           { minimal zu messende Spannung }
   {$ENDIF}

   {$IFDEF HP33120A}
   { Werte fr den Funktionsgenerator HP33120A }
   adr_fg    = 10;            { Adresse des Frequenzgen. }
   max_spg_fg= 10;            { max. Ausgangsspg. des Frequenzgen. }
   min_spg_fg= 0.05;          { minimal zu messende Spannung }
   {$ENDIF}

   {$IFDEF AGT33220A}
   { Werte fr den Funktionsgenerator Agilent 33220A }
   adr_fg    = 10;            { Adresse des Frequenzgen. }
   max_spg_fg= 10;            { max. Ausgangsspg. des Frequenzgen. }
   min_spg_fg= 0.01;          { minimal zu messende Spannung }
   {$ENDIF}

   {$IFDEF HP33250A}
   { Werte fr den Funktionsgenerator Agilent/HP33250A }
   adr_fg    = 10;            { Adresse des Frequenzgen. }
   max_spg_fg= 10;            { max. Ausgangsspg. des Frequenzgen. }
   min_spg_fg= 0.01;          { minimal zu messende Spannung }
   {$ENDIF}

   {$IFDEF PM5138}
   { Werte fr den Funktionsgenerator PM5138/PM5139 }
   adr_fg    = 9;             { Adresse des Frequenzgen. }
   max_spg_fg= 10;            { max. Ausgangsspg. des Frequenzgen. }
   min_spg_fg= 0.001;         { minimal zu messende Spannung }
   {$ENDIF}

{
**************************************************************************
**************************************************************************
}
Implementation

begin
end.