unit UnitExistPF;

interface

const // ��������� ������

      // ��������� �����
      GlavDoc   = 'TempPath\GlavDoc\';
      Pril      = 'TempPath\Pril\';
      PathUser  = 'User\';
      TempPath  = 'TempPath\';
      Paket     = 'Paket\';
      Arhivator = 'Arhivator\';
//-----------------------------------------------------------------
        // �������� ������������� ���� � �������� ����������
      function ExistsPath( var Path: string ): boolean;
        // �������� ������������� ���� � �������� ������������
      function ExistsPathUser(User: string; var Path: string ): boolean;
        // �������� ������������� �����
      function ExistsFile( NameFail: string ): string;
        // �������� ������������� ����� ������������
      function ExistsFileUser( User: string; NameFail: string ): string;
        // �������� ������ ������������
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
    ShowMessage('��� ����� ������������');
    Exit;
  end;

  Path:= PathUser + User + '\' + Path;
  Result:= ExistsPath(Path);
end;

function ExistsFile( NameFail: string ): string;
// ��������� ����� ���������� �� � ������� ���� ���� ��� ����
var p: string;
begin
  p:= GetPath(vrPathApp) + NameFail;
  Result:= '';

  if not FileExists(p) then
  begin
   ShowMessage('��� �����: ' + p);
   Exit;
  end
    else
     Result:= p;
end;

function ExistsFileUser( User: string; NameFail: string ): string;
var p,s: string;
begin
  if User = '' then User:= '<<������������ �� ������>>';
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
