{Lukass Rainbow-Doom, lukves@outlook.com}
Program rainbow_doom;

uses Crt, Dos, Graph;
type
  poloha=record
         a,b,fi:integer;
         end;
zoznam=file of poloha;

var palivo,naboje,X,Y,mapa,e,kn,Sizen,q,zbran,track,Large,opakn : LongInt;
    SoundCard,Help,Language:byte;
    Ch:char;
    X1, X2, Y1, Y2 : Integer;
    N1, N2, L,Mn:LongInt;
    BX1, BX2, BY1, BY2 : Integer;
    matrix: Array[0..3,0..50] Of LongInt;
    HUE, WHICH, BOUNCE :Integer;
    CHANGE, OPAK : Integer;
    zoz:zoznam;
    pol:poloha;
    p,sirka,ods,aa,bb,h,i,g,yy,xx,li1,li2:longint;
    pof,a2,b2,a,b,v1,v2,fi,j,d,j0:longint;
    m,n:array[1..40,1..40] of byte;
    sins,coss:array[-300..661] of integer;
    arctans:array[-502..502] of integer;
    blb,po,k,s,r,r1,r2:real;
    vyb,je,je2,kon:byte;
    size:word;
    med:pointer;
    z:char;

    aan,bbn,en,knn,kkn,ryn:integer;
    bn,dbn,x0n,y0n,ln,tn,dtn,gn,vn,x1n,x2n,y1n,y2n:real;
    konn:byte;
    xn,yn,zn:array[1..200] of real;
    lon:word;
    loon:pointer;
    stn:char;

procedure init;
var gd,gm,ge:integer;
begin
 gd:=installuserdriver('vga256',nil);
 initgraph(gd,gm,'c:\coloseus\bgi');
 ge:=graphresult;
 if ge<>0 then
 begin
  writeln(grapherrormsg(ge));
  halt(1);
 end
end;

procedure init2;
var gd,gm,ge:integer;
begin
 gd:=installuserdriver('vesa16',nil);
 initgraph(gd,gm,'c:\coloseus\bgi');
 ge:=graphresult;
 if ge<>0 then
 begin
  writeln(grapherrormsg(ge));
  halt(1);
 end
end;


Procedure FastWrite(TxT:String; Row,Col,Attr:Byte);
assembler;
asm
        PUSH    DS
        MOV     AX,$B800
        MOV     ES,AX
        MOV     CH,Row
        MOV     BL,Col
        XOR     AX,AX
        MOV     CL,AL
        MOV     BH,AL
        DEC     CH
        SHR     CX,1
        MOV     DI,CX
        SHR     DI,1
        SHR     DI,1
        ADD     DI,CX
        DEC     BX
        SHL     BX,1
        ADD     DI,BX
        LDS     SI,DWORD PTR [TxT]
        CLD
        LODSB
        XCHG    AX,CX
        JCXZ    @FWExit
        MOV     AH,Attr
@FWDisplay:
        LODSB
        STOSW
        LOOP    @FWDisplay
@FWExit:
        POP     DS
end;

Procedure ClearScreen(attr:Byte; znak:char; blok:word);
assembler;
asm
  MOV  AX, $B800
  MOV  ES, AX
  XOR  DI, DI
  MOV  CX, &BLOK
  MOV  AH, ATTR
  MOV  AL, &ZNAK
  REP  STOSW
end;

Procedure udaje;
begin
  N1:= 400;
  N2:= 400;
  FOR L:= 0 TO 3 DO Begin;
  FOR Mn:= 0 TO 50 DO Begin;
  matrix[L, Mn]:= 0;
  End;
  End;
  Randomize;
  HUE:=RANDOM(8);
  X1:= RANDOM(N1)+1;
  X2:= RANDOM(N2)+1;
  Y1:= RANDOM(192);
  Y2:= RANDOM(192);
end;

Procedure dynamic1;
Label 1;
Label 2;
Label 3;
Label 4;
Label 5;
Label 6;
begin;
   Setcolor(0);
   LINE (matrix[0, WHICH], matrix[1, WHICH],matrix[2, WHICH],matrix[3, WHICH]);
   BOUNCE:= BOUNCE - 1;
   If BOUNCE > 0 Then Begin
                         GoTo 1;
                      End;
   BOUNCE:= RANDOM(10) + 10;
   BX1:=RANDOM(9) - 4;
   BX2:=RANDOM(9) - 4;
   BY1:=RANDOM(13) - 6;
   BY2:=RANDOM(13) - 6;
1: CHANGE:= CHANGE - 1;
   If CHANGE > 0 Then Begin
                         GoTo 2;
                      End;
   CHANGE:=RANDOM(10) + 5;
   HUE:=RANDOM(8) + 1;
2: Setcolor(HUE);
   LINE (X1, Y1, X2, Y2);
   matrix[0, WHICH]:= X1;
   matrix[1, WHICH]:= Y1;
   matrix[2, WHICH]:= X2;
   matrix[3, WHICH]:= Y2;
   WHICH:= WHICH + 1;
   If WHICH > 50 Then WHICH:= 0;
3: X1:= X1 + BX1;
   If X1 < 0 Then Begin
                    BX1:= -BX1;
                    GoTo 3;
                  End;
   If X1 > 799 Then Begin
                     BX1:= -BX1;
                     GoTo 3;
                   End;
4: X2:= X2 + BX2;
   If X2 < 0 Then Begin
                    BX2:= -BX2;
                    GoTo 4;
                  End;
   If X2 > 799 Then Begin
                     BX2:= -BX2;
                     GoTo 4;
                   End;
5: Y1:= Y1 + BY1;
   If Y1 < 0 Then Begin
                    BY1:= -BY1;
                    GoTo 5;
                  End;
   If Y1 > 276 Then Begin
                      BY1:= -BY1;
                      GoTo 5;
                    End;
6: Y2:= Y2 + BY2;
   If Y2 < 0 Then Begin
                    BY2:= -BY2;
                    GoTo 6;
                  End;
   If Y2 > 276 Then Begin
                      BY2:= -BY2;
                      GoTo 6;
                    End;
end;


procedure ram;
begin
  SetFillStyle(11,3);
  floodfill(5,5,2);
  setcolor(11);
  rectangle(0,0,799,599);
end;

Procedure Wait; assembler;
asm
  MOV  AX, 0
  INT  16h
end;

procedure ddelay(i:integer);
begin
	{delay(round(d*k));}
	delay(i);
end;

var del:integer;

procedure c(c,d :integer);
begin if c=4 then q:=131;if c=5 then q:=262;if c=6 then q:=523;if c=7 then q:=1046;if c=8 then q:=2093;
 sound(q);ddelay(del); nosound;end;

procedure cis(c,d :integer);
begin if c=4 then q:=139;if c=5 then q:=277;if c=6 then q:=554;if c=7 then q:=1109;if c=8 then q:=2217;
 sound(q);ddelay(del); nosound;end;

procedure d_(c,d :integer);
begin if c=4 then q:=147;if c=5 then q:=294;if c=6 then q:=587;if c=7 then q:=1175;if c=8 then q:=2349;
 sound(q);ddelay(del); nosound;end;

procedure dis(c,d :integer);
begin if c=4 then q:=156;if c=5 then q:=311;if c=6 then q:=622;if c=7 then q:=1245;if c=8 then q:=2489;
 sound(q);ddelay(del); nosound;end;

procedure e_(c,d :integer);
begin if c=4 then q:=165;if c=5 then q:=329;if c=6 then q:=659;if c=7 then q:=1318;if c=8 then q:=2637;
 sound(q);ddelay(del); nosound;end;

procedure f(c,d :integer);
begin if c=4 then q:=175;if c=5 then q:=349;if c=6 then q:=698;if c=7 then q:=1397;if c=8 then q:=2794;
 sound(q);ddelay(del); nosound;end;

procedure fis(c,d :integer);
begin if c=4 then q:=185;if c=5 then q:=370;if c=6 then q:=740;if c=7 then q:=1480;if c=8 then q:=2960;
 sound(q);ddelay(del); nosound;end;

procedure g_(c,d :integer);
begin if c=4 then q:=196;if c=5 then q:=392;if c=6 then q:=784;if c=7 then q:=1568;if c=8 then q:=3136;
 sound(q);ddelay(del); nosound;end;

procedure gis(c,d :integer);
begin if c=4 then q:=208;if c=5 then q:=415;if c=6 then q:=831;if c=7 then q:=1661;if c=8 then q:=3322;
 sound(q);ddelay(del); nosound;end;

procedure a_(c,d :integer);
begin if c=4 then q:=220;if c=5 then q:=440;if c=6 then q:=880;if c=7 then q:=1760;if c=8 then q:=3520;
 sound(q);ddelay(del); nosound;end;

procedure ais(c,d :integer);
begin if c=4 then q:=233;if c=5 then q:=466;if c=6 then q:=932;if c=7 then q:=1865;if c=8 then q:=3729;
 sound(q);ddelay(del); nosound;end;

procedure h_(c,d :integer);
begin if c=4 then q:=247;if c=5 then q:=494;if c=6 then q:=988;if c=7 then q:=1976;if c=8 then q:=3951;
 sound(q);ddelay(del); nosound;end;


procedure bod(x0n,y0n,x1n,x2n,y1n,y2n:real;cn:integer);
var en,fn:integer;
    gn:real;
begin
setcolor(cn);
if (x0n>x1n) and (x0n<x2n) and (y0n>y1n) and (y0n<y2n) then
                   putpixel(round(x0n+320),round(y0n+240),cn);
end;

Procedure Param;
begin
  bn:=0;
  konn:=0;tn:=0;dtn:=1;ln:=80;vn:=30;knn:=100;kkn:=200;ryn:=1;bn:=0;dbn:=0.0001;
  x1n:=-308;x2n:=308;y1n:=-228;y2n:=140;
  randomize;
end;


Procedure Pixel(x,y:integer; col:Byte);
begin
asm
   mov  ax,y
   shl  ax,1
   shl  ax,1
   shl  ax,1
   shl  ax,1
   shl  ax,1
   shl  ax,1
   mov  bx,ax
   shl  ax,1
   shl  ax,1
   add  bx,ax
   add  bx,x
   mov  ax,$a000
   push ax
   pop  es
   mov  al,col
   mov  es:[bx],al
end;
end;

function sqrt2(num:longint):word;
var hi,lo,result:word;
begin
 hi:=num shr 16;
 lo:=num mod 65536;
 asm
  cwd
  mov ax,lo
  mov dx,hi
  mov bx,65535
  mov cx,0
  @@looping:
   inc cx
   add bx,2
   sub ax,bx
   jnc @@looping
   sub dx,1
   jc @@koniec
  jmp @@looping
  @@koniec:
  add ax,bx
  sub bx,ax
  cmp bx,cx
  jb @@nic
  dec cx
  @@nic:
  mov result,cx
 end;
 sqrt2:=result
end;
procedure put_pix(x,y:word;color:byte);assembler;
asm
  mov ax,320
  mul y
  add ax,x
  mov di,0a000h
  mov es,di
  mov di,ax
  mov al,color
  mov es:[di],al
end;


procedure line_vert(x,y1,y2:word;color:byte);assembler;
 asm
  mov ax,y1
  mov bx,y2
  cmp ax,bx
  jg @@asd
   xchg ax,bx
   cmp ax,bx
   jne @@asd
   mov ax,320
   mul bx
   add ax,x
   mov dx,0a000h{word(virtscr+2)}
   mov es,dx
   mov di,ax
   mov al,color
   stosb
   jmp @@koniec
  @@asd:
  sub ax,bx
  mov cx,ax
  mov ax,320
  mul bx
  add ax,x
  mov dx,0a000h{word(virtscr+2)}
  mov es,dx
  mov di,ax
  mov al,color
  @@l1:
   stosb
   add di,319
  loop @@l1
  @@koniec:
 end;

procedure nacitanie;
begin
for h:=-300 to 660 do begin
  sins[h]:=round(1000*sin(h*pi/180));
  coss[h]:=round(1000*cos(h*pi/180));
end;
for h:=-200 to 200 do begin
  arctans[h]:=round(arctan(h/200)*180/pi);
end;
end;

function sqrtt(b:real):real;
var a,n:integer;
    z:char;
begin
a:=1;n:=0;
repeat
a:=a+2;
b:=b-a;
n:=n+1;
until b<0;
sqrtt:=n;
end;

procedure kresli(farba:integer);
var pos,posx,posy,fa,blb1:integer;

begin
  setcolor(farba);
  fa:=farba;
  j0:=160;
  j:=-j0;
  repeat
  inc(j);
    blb1:=fi;
    v1:=(d*coss[blb1]-j*sins[blb1]) div 1000;
    v2:=(d*sins[blb1]+j*coss[blb1]) div 1000;
      li1:=1;pos:=1;
      blb1:=(fi-arctans[-1*((200*j) div d)]);
      if (coss[blb1]>=0) then begin
         li1:=(a div l)+1;
         li1:=round(int(a/l))+1;
         pos:=1;end else begin
         li1:=a div l;
         li1:=round(int(a/l));
         pos:=-1;end;
      repeat
        if (abs(v1)>0.01) then y:=(v1*b-v2*a+v2*li1*l) div (v1);
        yy:=(y div l);
        if m[li1,yy]=1 then je:=1;
        if y>20*l then je:=2;
        if y<1 then je:=2;
        li1:=li1+pos;
      until (je=1) or (keypressed) or (li1>20) or (li1<=0) or (je=2);
      if (je=2) then je:=0;
   r1:=sqrt(sqr(abs(a-li1*l)-l)+sqr(b-y));
  je2:=0;
  li2:=1;pos:=1;
      if (sins[blb1]>=0) then begin
         li2:=(b div l)+1;
         li2:=round(int(b/l))+1;
         pos:=1;end else begin
         li2:=b div l;
         li2:=round(int(b/l));
         pos:=-1;end;
      repeat
        if (abs(v2)>0.01) then x:=(v2*a-v1*b+li2*l*v1) div (v2);
        xx:=x div l;
        if n[xx,li2]=1 then je2:=1;
        if x>20*l then je2:=2;
        if x<1 then je2:=2;
        li2:=li2+pos;
      until (je2=1) or (keypressed) or (li2>20) or (li2<=0) or (je2=2);
            if (je2=2) then je2:=0;
    r2:=sqrt(sqr(abs(b-li2*l)-l)+sqr(a-x));

    blb:=d/sqrt(j*j+d*d);
    if ((r1>=r2) and (r2>1)) or ((r1<=1) and (r2>1)) then begin
         r:=(r2*blb);
        if (farba<>0) and
        ((abs(x-xx*l)<2) or (abs(l-x+xx*l)<2)) then fa:=7 else fa:=farba;
      end;
    if ((r2>r1) and (r1>1)) or ((r2<=1) and (r1>1)) then begin
        r:=(r1*blb);
        if (farba<>0) and
        ((abs(y-yy*l)<2) or (abs(l-y+yy*l)<2)) then fa:=7 else fa:=farba;
      end;
    line_vert(-j+160,100-(sirka div 3),100+(sirka div 3),0);

    setcolor(fa+random(2));

    if (je=1) or (je2=1) then begin
      p:=round(sirka*((d/10)*k)/(r*2*300));
      fa:=fa+8+round(sirka*((d/10)*k)/(r*8*300));
    if ((je=1) or (je2=1)) then
    if (abs(p)<sirka/3) then begin
       line_vert(-j+160,100-p,100+p,fa);
       line_vert(-j+160,0,100-p,0);
       line_vert(-j+160,100+p,200,0);
     end
     else
    line_vert(-j+160,100-(sirka div 3),100+(sirka div 3),fa) ;
    end;
    je:=0;
  until (j>=j0) or (keypressed);
end;


procedure subory;
var vybs:byte;
begin
assign(zoz,'c:\coloseus\colos.dat');
reset(zoz);
vybs:=1;
    PutImage(115,15*vyb+35,med^,xORPut);
    kresli(9);
    settextstyle(0,0,0);
    setcolor(9);
    if (vyb=2) then begin
                   outtextxy(130,30,'LOAD MENU');

                    end;
    if (vyb=3) then begin
                   outtextxy(130,30,'SAVE MENU');
       
                    end;
    setcolor(14);
                         outtextxy(130,50,'position1');
                         outtextxy(130,65,'position2');
                         outtextxy(130,80,'position3');
                         outtextxy(130,95,'position4');
                         outtextxy(130,110,'position5');

    z:='0';
    PutImage(115,15*vybs+35,med^,xORPut);
    repeat
      if keypressed then begin
        z:=readkey;
        PutImage(115,15*vybs+35,med^,xORPut);
        if z=#0 then begin
          z:=readkey;
          if (z=#80) and (vybs<5) then vybs:=vybs+1;
          if (z=#72) and (vybs>1) then vybs:=vybs-1;
        end;
        PutImage(115,15*vybs+35,med^,xORPut);
        if (z=#27) then kresli(9);
        if (z=#13) and (vyb=2) then begin
          seek(zoz,vybs-1);
          read(zoz,pol);
          a:=pol.a;
          b:=pol.b;
          fi:=pol.fi;
          z:=#27;
          kresli(9);
        end;
        if (z=#13) and (vyb=3) then begin
          seek(zoz,vybs-1);
          pol.a:=a;
          pol.b:=b;
          pol.fi:=fi;
          write(zoz,pol);
          z:=#27;
          kresli(9);
        end;
      end;
    until (z=#27) or (kon=1);
close(zoz);
kon:=0;
end;

Begin
  DEL:=1;

  TextColor(7);
  Writeln('LANGUAGE : 0.. English');
  Writeln('           1.. Czech');
  Writeln('           2.. Slovak');
  ch:=Readkey;
  If ch='0' then Language:=0;
  If ch='1' then Language:=1;
  If ch='2' then Language:=2;
  SoundCard:=1;
  Help:=1;
  {ZobrazPcx('C:\coloseus\picture\gamepic\pocitac.pcx');}
  wait;
  naboje:=1000;
  palivo:=10000000;
  Param;
  init2;
  Setcolor(6);
  line(0,278,799,278);
  Setcolor(8);
  line(0,279,799,279);
  Setcolor(4);
  line(0,280,799,280);
  line(0,479,799,479);
  Setcolor(8);
  line(0,480,799,480);
  Setcolor(6);
  line(0,481,799,481);
  e:=0;
  If Help=1 then begin
                 
                                        Setcolor(6);
                                        outtextXY(0,580,'Press any key to continue ...');
             
                 end;
  udaje;
  Large:=0;
  Repeat
  begin
  if e=1000  then e:=0;
  Setcolor(4);
  Sizen:=6;
  Y:=350;
  e:=e+10;
  SetTextStyle(DefaultFont, HorizDir, Sizen);
  OutTextXY(0+e, Y, 'C O L O S E U S');
  Inc(Y, TextHeight('C O L O S E U S'));
  Setcolor(0);
  Sizen:=6;
  Y:=350;
  SetTextStyle(DefaultFont, HorizDir, Sizen);
  OutTextXY(0+e, Y, 'C O L O S E U S  I.');
  Inc(Y, TextHeight('C O L O S E U S  I.'));
  end;
  dynamic1;
  Sizen:=2;
  SetTextStyle(DefaultFont, HorizDir, Sizen);
  Large:=Large+1;
  If Large=500 then Large:=0;
  OutTextXY(500-Large,500,'Lukass Rainbow-Doom');
  SetColor(0);
  OutTextXY(500-Large,500,'Lukass Rainbow-Doom');
  If SoundCard=1 then begin
                       g_(5,200);e_(5,200);c(5,200);e_(5,200);g_(5,100);f(5,100);e_(5,100);f(5,100);
                       d_(5,400);g_(5,200);e_(5,200);c(5,200);e_(5,200);g_(5,100);f(5,100);e_(5,100);
                       f(5,100);d_(5,400);c(6,200);c(6,100);h_(5,100);a_(5,400);g_(5,200);g_(5,100);
                       f(5,100);e_(5,400);d_(5,400);
                     end;

  until Keypressed;
  CloseGraph;
  ClearScreen(78,' ',2000);

                       FastWrite('Its time we started!',1,2,66);
                       FastWrite('  You are near of the some planet,her name is Zorgos.',4,1,65);
                       FastWrite('On this planet was living very inteligent people, but som cosmic robots',5,1,65);
                       FastWrite('was destroyed city and created new...',6,1,65);
                       FastWrite('You are a prototype a super-robot.',7,1,65);
                       FastWrite('You get this letter: ',8,1,65);
                       FastWrite('SOS...SOS...SOS...SOS...SOS...',8,23,64);
                       FastWrite('Come on super-robot...',9,23,64);
                       FastWrite('Go on,of your work!...',10,23,64);
                       FastWrite('Please go fast, will you... Please go fast, will you...',11,23,64);
                       FastWrite('Your answer: Ill come and fetch you from the new house...',14,1,65);
                       FastWrite('Please, press any key to continue ...',25,40,67);

  wait;
  wait;
  aa:=detect;
  init;
  setcolor(12);
  for i:=1 to 4 do circle(5,5,i);
  setcolor(14);
  circle(5,5,4);
  Size:=ImageSize(1,1,10,10);
  GetMem(med,Size);
  GetImage(1,1,10,10,med^);
  for h:=1 to 40 do
      for i:=1 to 40 do begin
      m[h,i]:=0;n[h,i]:=0;
      end;

      for h:=1 to 19 do begin m[20,h]:=1;m[1,h]:=1;end;
      for h:=1 to 19 do begin n[h,20]:=1;n[h,1]:=1;end;

      for h:=10 to 19 do begin m[10,h]:=1;end;
      for h:=10 to 19 do begin m[11,h]:=1;end;

      for h:=2 to 9 do begin n[h,9]:=1;end;
      for h:=2 to 9 do begin n[h,10]:=1;end;
      for h:=11 to 15 do begin n[h,10]:=1;n[h,9]:=1;end;
      for h:=1 to 8 do begin m[2,h]:=1;m[2,h+10]:=1;end;
      m[2,10]:=1;

      for h:=2 to 8 do begin m[10,h]:=1;m[11,h]:=1;end;
      for h:=3 to 9 do n[h,2]:=1;
      for h:=2 to 7 do begin m[3,h]:=1;m[9,h]:=1;end;
      for h:=3 to 5 do n[h,8]:=1;
      n[7,8]:=1;n[8,8]:=1;
      for h:=17 to 19 do begin n[h,10]:=1;n[h,9]:=1;end;
      for h:=10 to 18 do begin m[16,h]:=1;m[17,h]:=1;end;
vyb:=1;
l:=100;
d:=200;s:=20/150;
k:=800;
a:=1840;b:=1040;
a:=150;b:=750;
fi:=0;
kon:=0;po:=40;pof:=20;
ods:=10;
sirka:=300;
nacitanie;
kresli(9);
repeat
palivo:=palivo-1;
if palivo<0 then begin
 
                                        outtextxy(10,30,'Sory, but you dont have a energy...');
                                        Sizen:=4;
                                        SetTextStyle(DefaultFont, HorizDir, Sizen);
                                        SetColor(4);
                                        OutTextXY(100, 100, 'EXIT');
                                        WAIT;
                    

                                      kon:=1;
                 end;
if (help=1) and (round(a*5/l)<50) and (round(a*5/l)>10) and (round(b*5/l)>50) then begin
                                                  outtextxy(10,10,'You are in the big room...');
                                                 
                                                  end;
if (help=1) and (round(a*5/l)<10) and (round(b*5/l)>50) then begin
                                                  outtextxy(10,10,'The way to big room...');
                                                 
                                                  end;
if (help=1) and (round(a*5/l)<10) and (round(b*5/l)<50) then begin
                                             
                                                                       outtextxy(10,10,'Go to big room,');
                                                                       outtextxy(10,20,'and destroyed energy-system...');
                                                               
                                        
                                                  end;
if mapa=1 then begin
                 for h:=1 to 20 do
                   for i:=1 to 20 do begin
                   if n[i,h]=1 then for g:=1 to 5 do
                   put_pix(200+g+i*5,200-h*5,15);
                   if m[i,h]=1 then for g:=1 to 5 do
                   put_pix(200+i*5,195+g-h*5,15);
                   end;
                   put_pix(200+round(a*5/l),200-round(b*5/l),12);
               end;
if zbran=1 then begin
                  line(100,100,108,100);
                  line(112,100,120,100);
                  line(110,90,110,98);
                  line(110,102,110,110);
                end;
if (keypressed) or (kon=3) then begin
  if kon<>3 then begin
  z:=readkey;
  case z of
  #0:begin
      z:=readkey;
      case z of
      #77: fi:=fi-pof;
      #75: fi:=fi+pof;
      end;
      if (z=#72) or (z=#80) then begin
      if z=#80 then po:=-po;
      a2:=round(a+po*cos(fi*pi/180));b2:=round(b+po*sin(fi*pi/180));
      if z=#80 then po:=-po;
      if ((round(int(a2+ods)) div round(l))>(round(int(a)) div round(l))) and
         (m[round(int(a2+ods)) div round(l),round(int(b)) div round(l)]=1)
         or
         ((round(int(a2-ods)) div round(l))<(round(int(a)) div round(l))) and
         (m[round(int(a)) div round(l),round(int(b)) div round(l)]=1)
         or
         ((round(int(b2+ods)) div round(l))>(round(int(b)) div round(l))) and
         (n[round(int(a)) div round(l),round(int(b2+ods)) div round(l)]=1)
         or
         ((round(int(b2-ods)) div round(l))<(round(int(b)) div round(l))) and
         (n[round(int(a)) div round(l),round(int(b)) div round(l)]=1)
         then
         else begin a:=a2;b:=b2;end;
      end;
    end;
  end;
  if z='e' then mapa:=1;
  if z='r' then mapa:=0;
  if z='a' then begin
                  for aa:=1 to 10 do begin
                                       if naboje>0 then circle(110,100+aa*10,10+aa);
                                       naboje:=naboje-1;
                                       if naboje<100 then begin
                                            outtextxy(10,30,'You have quite munition...');
                                                    
                                                            end;
                                     end;
                end;
  if z='z' then zbran:=1;
  if z='y' then zbran:=0;
  if (z='+') and (sirka<300) then begin
      sirka:=sirka+20;  for h:=1 to 320 do line_vert(h,0,200,0);
  end;
  if (z='-') and (sirka>80) then begin
      sirka:=sirka-20;  for h:=1 to 320 do line_vert(h,0,200,0);
  end;
  if fi<0 then fi:=fi+360;
  if fi>360 then fi:=fi-360;
  if z='q' then kon:=1;

  if (z<>'q') and (z<>'m') then begin
                                  kresli(9);
                                end;
  if a>2000 then kon:=2;
 end;
  if (kon=3) and (keypressed) then z:=readkey;
  if (z=#27) then begin
    setcolor(11);
    settextstyle(0,0,0);
        outtextxy(130,50,'NEW GAME');
        outtextxy(130,65,'LOAD GAME');
        outtextxy(130,80,'SAVE GAME');
        outtextxy(130,95,'OPTIONS');
        outtextxy(130,110,'QUIT GAME');
 
    z:='0';
    PutImage(115,15*vyb+35,med^,xORPut);
    repeat
      if keypressed then begin
        z:=readkey;
        PutImage(115,15*vyb+35,med^,xORPut);
        if z=#0 then begin
          z:=readkey;
          if (z=#80) and (vyb<5) then vyb:=vyb+1;
          if (z=#72) and (vyb>1) then vyb:=vyb-1;
        end;
        PutImage(115,15*vyb+35,med^,xORPut);
        if (z=#27) then kresli(9);
        if (z=#13) then begin
          if (vyb=1) then begin
             a:=150;b:=750;
             kon:=0;
             fi:=0;
             kresli(9);
             z:=#27;
          end;
          if (vyb=2) or (vyb=3) then subory;
          if vyb=4 then begin
                          Language:=Language+1;
                          If Language=4 then Language:=0;
                          kon:=4;
                        end;
          if (vyb=5) then kon:=1;
        end;
      end;
    until (z=#27) or (kon=1);
  end;
  if z='m' then begin
  clearviewport;
  Sizen:=2;
  SetColor(4);
  SetTextStyle(DefaultFont, HorizDir, Sizen);
  OutTextXY(10, 20, 'C O L O S E U S  RAINBOW-DOOM');
  setcolor(15);
  for h:=1 to 20 do
    for i:=1 to 20 do begin
      if n[i,h]=1 then for g:=1 to 5 do
        put_pix(50+g+i*5,150-h*5,15);
      if m[i,h]=1 then for g:=1 to 5 do
        put_pix(50+i*5,145+g-h*5,15);
    end;
  put_pix(50+round(a*5/l),150-round(b*5/l),12);
  repeat
  until keypressed;
  for h:=1 to 320 do line_vert(h,0,200,0);
  end;
end;
if (kon=2) then begin
  settextstyle(1,0,2);
  if kon=2 then begin
                     begin
                       OutTextXY(100,80,'YOU WON !');
                       wait;
                       {ZobrazPcx('C:\coloseus\picture\gamepic\wily.pcx');}
                     end;
    repeat until (keypressed);
  z:='0';
  z:=readkey;
  z:=#27;
  kon:=3;
  end;
end;
until (kon=1);
closegraph;

End.