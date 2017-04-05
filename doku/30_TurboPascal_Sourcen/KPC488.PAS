{
  Copyright (C) 1993, 1994
  Fachhochschule fÅr Technik Esslingen, Labor fÅr Hochspannungstechnik
  Programmierer: Uwe Weidlich
}

{$I OPTIONS.INC}   { Turbo Pascal 5.0 - 6.0 Compiler Optionen }

Unit KPC488;

Interface

Uses IEEEPAS;

var Status:Integer;

Procedure Init_IEEE_Board;
Procedure Sende(Addr:Byte; s:String);
Procedure DeviceClear;
Procedure GoToLocal(Addr:Byte);

Implementation

Procedure Init_IEEE_Board;
var My_Address, System_Controller:Integer;
begin
  My_Address:=21;
  System_Controller:=0;
  Initialize(My_Address, System_Controller);
  if GPIB_Board_Present = 0 then
  begin
    Writeln('GPIB-Board nicht installiert !');
    Halt(1);
  end;
end; {Procedure Init_IEEE_Board}

Procedure Sende(Addr:Byte; s:String);
var Status:Integer;
begin
  Send(Addr, s, Status);
  if Status <> 0 then
  begin
    Writeln('Fehler beim Senden:');
    Writeln('  Prozedur: Send, aufgerufen von Sende');
    Writeln('  GerÑteadresse=', Addr);
    Writeln('  Befehl=', s);
    Writeln('  Status=', Status);
  end; {if Status <> 0}
end; {Procedure Sende}

Procedure DeviceClear;
var Cmd:String;
begin
  Cmd:='IFC DCL';
  Transmit(Cmd, Status);
  if Status <> 0 then
  begin
    Writeln('Fehler beim Senden:');
    Writeln('  Prozedur: Transmit, aufgerufen von DeviceClear');
    Writeln('  Befehl=', Cmd);
    Writeln('  Status=', Status);
  end; {if Status <> 0}
end; {Procedure DeviceClear}

Procedure GoToLocal(Addr:Byte);
var Address:String[2];
    Cmd:String;
begin
  Str(Addr, Address);
  Cmd:='GTL '+Address+' UNL '+ Address;
  Transmit(Cmd, Status);
  if Status <> 0 then
  begin
    Writeln('Fehler beim Senden:');
    Writeln('  Prozedur: Transmit, aufgerufen von GoToLocal');
    Writeln('  GerÑteadresse=', Addr);
    Writeln('  Befehl=', Cmd);
    Writeln('  Status=', Status);
  end; {if Status <> 0}
end; {Procedure GoToLocal}

{Initialisierung}

begin
end.
