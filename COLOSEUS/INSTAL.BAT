@echo off
Cls

echo Teraz nasleduj?bli§çie informacie o inçtalacii ...
pause
A:\COLOSEUS\INSTAL\IPRG\instal.exe

if not exist C:\COLOSEUS GoTo pokracuj
GoTo End

:pokracuj
MD C:\COLOSEUS
copy A:\coloseus C:\coloseus
del C:\coloseus\instal.bat

MD C:\COLOSEUS\BGI
copy A:\coloseus\bgi C:\coloseus\bgi
MD C:\coloseus\TPU
copy A:\coloseus\tpu C:\coloseus\tpu
MD C:\coloseus\LEVEL
copy A:\coloseus\level C:\coloseus\level
MD C:\COLOSEUS\PICTURE
MD C:\COLOSEUS\PICTURE\GAMEPIC
MD C:\COLOSEUS\TXTFILE
MD C:\COLOSEUS\TXTFILE\SLOTXT
copy A:\coloseus\picture\gamepic C:\coloseus\picture\gamepic
copy A:\coloseus\txtfile\slotxt C:\coloseus\txtfile\slotxt

:End