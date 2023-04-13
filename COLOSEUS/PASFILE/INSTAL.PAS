Program Instal;
{VESIsoft (C)1998}
uses Crt;

Var  F,h: text;
     obsah:string;
     e:ShortInt;
     a:Longint;

Procedure Wait; assembler;
asm
  MOV  AX, 0
  INT  16h
end;

begin
 Assign(F, 'C:\coloseus\instal\txtfile\help.txt');
 Reset(F);
 ClrScr;
 e:=2;
 repeat
    TextColor(4);
    GotoXY(1,1);
    Write('Lukass Rainbow-Doom');
    TextColor(7);
    GotoXY(1,e);
    Readln(F, obsah);
    Writeln(obsah);
    e:=e+1;
 until e=25;
 WAIT;
end.
