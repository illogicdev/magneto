UNIT ieeepas;
{
        Turbo Pascal UNIT to interface IEEE-488 subroutines

        Copyright (C) 1989 Capital Equipment Corp.
}

{----------------------------------------------------------------------}
INTERFACE
{----------------------------------------------------------------------}

procedure initialize (addr,level : integer);
procedure transmit (cmd : string; var status : integer);
procedure receive (var s : string; maxlen : word; var len : word;
                   var status : integer);
procedure send (addr : integer; s : string; var status : integer);
procedure enter (var s : string; maxlen : word; var len : word;
                 addr : integer; var status : integer);
procedure spoll (addr : integer; var poll : byte; var status : integer);
procedure ppoll (var poll : byte);
procedure tarray (var d; count : word; eoi : boolean; var status : integer);
procedure rarray (var d; count : word; var len : word; var status : integer);

function srq : boolean;

procedure setport (boardnum : integer; ioaddr : word);
procedure boardselect (boardnum : integer);
procedure dmachannel (c : integer);
procedure settimeout (t : word);
procedure setoutputEOS (eos1,eos2 : byte);
procedure setinputEOS (eos : byte);

procedure ieeecommands (var cmds; count : word;var status : integer);
procedure ieeeatn (atn : boolean; var status : integer);
procedure ieeeren (ren : boolean);
procedure ieeeoutp (reg : word;value : byte);
function ieeeinp (reg : word) : byte;
procedure enable_488ex (enable : boolean);
procedure enable_488sd (enable : boolean; timing : integer);
function listener_present (addr : integer) : boolean;
function gpib_board_present : byte;
function gpib_feature (f: integer) : integer;

{ Feature inquiry codes for gpib_feature routine }
const
   { Hardware features }
   IEEEListener = 0;
   IEEE488SD = 1;
   IEEEDMA = 2;
   { Hardware settings }
   IEEEIOBASE = 100;
   { Software settings }
   IEEETIMEOUT = 200;
   IEEEINPUTEOS = 201;
   IEEEOUTPUTEOS1 = 202;
   IEEEOUTPUTEOS2 = 203;
   IEEEBOARDSELECT = 204;
   IEEEDMACHANNEL = 205;

{----------------------------------------------------------------------}
IMPLEMENTATION
{----------------------------------------------------------------------}

{$F+}
procedure ieee488_initialize (addr,level : integer);
        external;
procedure ieee488_transmit (cmd : pointer; cmdlen : integer; var status : integer);
        external;
procedure ieee488_receive (s : pointer; maxlen : word; var len : word;
                   var status : integer);
        external;
procedure ieee488_send (addr : integer; c : pointer; len : integer; var status : integer);
        external;
procedure ieee488_enter (c : pointer; maxlen : word; var len : word;
                 addr : integer; var status : integer);
        external;
procedure ieee488_spoll (addr : integer; var poll : byte; var status : integer);
        external;
procedure ieee488_ppoll (var poll : byte);
        external;
procedure ieee488_tarray (var d; count : word; eoi : boolean;
                 var status : integer);
        external;
procedure ieee488_rarray (var d; count : word; var len : word;
                 var status : integer);
        external;

function ieee488_srq : boolean;
        external;
function ieee488_srqevent : boolean;
        external;

procedure ieee488_setport (boardnum : integer; ioaddr : word);
        external;
procedure ieee488_boardselect (boardnum : integer);
        external;
procedure ieee488_dmachannel (c : integer);
        external;
procedure ieee488_settimeout (t : word);
        external;
procedure ieee488_setoutputEOS (eos1,eos2 : byte);
        external;
procedure ieee488_setinputEOS (eos : byte);
        external;
procedure ieee488_dma2; external;

procedure ieee488_commands (cmds : pointer; count : word; var status : integer);
          external;
procedure ieee488_atn (atn : boolean;var status : integer);
          external;
procedure ieee488_ren (ren : boolean);
          external;
procedure ieee488_outp (reg:word;value : byte);
        external;
function ieee488_inp (reg : word) : byte;
        external;
procedure ieee488_setatnmode (softwaremode : boolean); external;

procedure ieee488_enable_488ex (e : boolean); external;
procedure ieee488_enable_488sd (e : boolean; t : integer); external;
function ieee488_listener_present (a : integer) : boolean; external;
function ieee488_board_present : byte; external;
function ieee488_feature (f : integer) : integer; external;

{----------------------------------------------------------------------}

procedure initialize;
begin
        ieee488_initialize(addr,level);
end;
procedure transmit;
var
        c : pointer;
        l : integer;
begin
        c := Ptr(Seg(cmd),Ofs(cmd)+1);
        l := length(cmd);
        ieee488_transmit(c,l,status);
end;
procedure receive;
var
        c : pointer;
begin
        c := Ptr(Seg(s),Ofs(s)+1);
        ieee488_receive(c,maxlen,len,status);
        s[0] := char(len);
end;
procedure send;
var
        c : pointer;
        l : integer;
begin
        c := Ptr(Seg(s),Ofs(s)+1);
        l := length(s);
        ieee488_send(addr,c,l,status);
end;
procedure enter;
var
        c : pointer;
begin
        c := Ptr(Seg(s),Ofs(s)+1);
        ieee488_enter(c,maxlen,len,addr,status);
        s[0] := char(len);
end;
procedure spoll;
begin
        ieee488_spoll(addr,poll,status);
end;
procedure ppoll;
begin
        ieee488_ppoll(poll);
end;
procedure tarray;
begin
        ieee488_tarray(d,count,eoi,status);
end;
procedure rarray;
begin
        ieee488_rarray(d,count,len,status);
end;
function srq;
begin
        srq := ieee488_srq;
end;
procedure setport;
begin
        ieee488_setport(boardnum,ioaddr);
end;
procedure boardselect;
begin
        ieee488_boardselect(boardnum);
end;
procedure dmachannel;
begin
        ieee488_dmachannel(c);
end;
procedure settimeout;
begin
        ieee488_settimeout(t);
end;
procedure setoutputEOS;
begin
        ieee488_setoutputEOS(eos1,eos2);
end;
procedure setinputEOS;
begin
        ieee488_setinputEOS(eos);
end;
procedure ieeecommands;
var
   c : pointer;
begin
     c := Ptr (Seg(cmds),Ofs(cmds));
     ieee488_commands (c,count,status);
end;
procedure ieeeatn;
begin
     ieee488_atn (atn,status);
end;
procedure ieeeren;
begin
     ieee488_ren (ren);
end;
procedure ieeeoutp;
begin
     ieee488_outp (reg,value);
end;
function ieeeinp;
begin
     ieeeinp := ieee488_inp (reg);
end;

procedure enable_488ex;
begin
     ieee488_enable_488ex(enable);
end;
procedure enable_488sd;
begin
     ieee488_enable_488sd(enable,timing);
end;
function listener_present;
begin
     listener_present := ieee488_listener_present(addr);
end;
function gpib_board_present;
begin
     gpib_board_present := ieee488_board_present;
end;
function gpib_feature;
begin
     gpib_feature := ieee488_feature(f);
end;

{$L pas488.obj}

end.


