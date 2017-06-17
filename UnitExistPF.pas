unit UnitExistPF;

interface

const // Константы файлов

      // Константы путей
      GlavDoc   = 'TempPath\GlavDoc\';
      Pril      = 'TempPath\Pril\';
      PathUser  = 'User\';
      TempPath  = 'TempPath\';
      Paket     = 'Paket\';
      Arhivator = 'Arhivator\';
//-----------------------------------------------------------------
        // Проверка существования пути в каталоге приложения
      function ExistsPath( var Path: string ): boolean;
        // Проверка существования пути в каталоге пользователя
      function ExistsPathUser(User: string; var Path: string ): boolean;
        // Проверка существования файла
      function ExistsFile( NameFail: string ): string;
        // Проверка существования файла пользователя
      function ExistsFileUser( User: string; NameFail: string ): string;
        // Проверка файлов пользователя
      function ExistsAllFileUser( User: string ): boolean;
implementation

uses SysUtils, Dialogs, UnitReg;

function ExistsPath( var Path: string ): boolean;
var i: word;
begin
  Result:= true;
 try
  Path:= GetPath(vrPathApp) + Path;

 if not DirectoryExists(Path) then
  ForceDirectories(Path);
 except
  Result:= false;
 end;
end;

function ExistsPathUser(User: string; var Path: string ): boolean;
begin
  if User = '' then
  begin
    ShowMessage('Нет имени пользователя');
    Exit;
  end;

  Path:= PathUser + User + '\' + Path;
  Result:= ExistsPath(Path);
end;

function ExistsFile( NameFail: string ): string;
// Проверить файлы приложения ну и вернуть путь если они есть
var p: string;
begin
  p:= GetPath(vrPathApp) + NameFail;
  Result:= '';

  if not FileExists(p) then
  begin
   ShowMessage('Нет файла: ' + p);
   Exit;
  end
    else
     Result:= p;
end;

function ExistsFileUser( User: string; NameFail: string ): string;
var p,s: string;
begin
  if User = '' then User:= '<<Пользователь не найден>>';
  p:= PathUser + User + '\' + NameFail;
  Result:= ExistsFile(p);
end;

function ExistsAllFileUser( User: string ): boolean;
var p,s: string;
begin
  Result:= true;
  p:= PathUser + User + '\';

  if not ExistsPath(p) then Exit;

  s:= ExistsFile(p+ 'EMail.dbf');

  if s = '' then
   Result:= false;
end;

end.
