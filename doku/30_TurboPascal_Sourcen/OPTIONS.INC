{
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*                                                                             *
* Datei OPTIONS.INC                                                13.04.1995 *
*                                                                             *
* Include-Datei mit Standard Compiler-Schaltern fÅr Turbo Pascal 5.5, 6.0     *
* und 7.0 sowie Borland Pascal 7.0.                                           *
* Globale Schalter mÅssen grundsÑtzlich nach einem einleitenden               *
* PROGRAM oder UNIT und vor jedem anderen Teil des Programms stehen !         *
* Lokale Schalter kînnen an beliebiger Stelle des Programms stehen.           *
*                                                                             *
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
}

{ Compiler-Schalter fÅr Turbo Pascal 5.5 }

{$A+}                   { Align data             Word }
{$B-}                   { Boolean evaluation     Short Circuit }
{$D+}                   { Debug information      On }
{$E+}                   { Emulation              On }
{$F-}                   { Force far calls        Off }
{$I+}                   { I/O checking           On }
{$L+}                   { Local symbols          On }
{$M $4000, 0, $A0000}   { Memory sizes           Stack, MinHeap, MaxHeap }
{$N+}                   { Numeric processing     8087/80287 }
{$O-}                   { Overlays allowed       Off }
{$R+}                   { Range-checking         On }
{$S+}                   { Stack checking         On }
{$V+}                   { Var-string checking    Strict }

{ zusÑtzliche Compiler-Schalter Turbo Pascal 6.0 }

{$IFDEF VER60}
  {$G-}                 { 286 instructions       On }
  {$X+}                 { Extended Syntax        On }
{$ENDIF}

{ zusÑtzliche Compiler-Schalter Turbo Pascal 7.0 }

{$IFDEF VER70}
  {$G-}                 { 286 instructions       On }
  {$K-}                 { Smart Callbacks        Off    (Windows) }
  {$P-}                 { Open Parameters        Off }
  {$Q+}                 { Overflow Checking      On }
  {$T-}                 { Typed @-Operator       Off }
  {$W-}                 { Windows-Stack-Frames   Off    (Windows) }
  {$X+}                 { Extended Syntax        On }
  {$Y+}                 { Symbol Information     On     (BP/BPW) }
{$ENDIF}
