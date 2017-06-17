{ **** UBPFD *********** by delphibase.endimus.com ****
>> ��������� ���� ������ �� ����������� �� ��������� TMemoryStream
(������������ ������ ������ windows)

��������� �������� ��� ����� �� �����������. ���� ���� ������� -
������ false, ���� ����� ��������� - true. ���� ��������� ������ ������� -
�������� ������������� �������������� ������� delphi , ����� ��� sysutils ,
classes , ���� �� ������ ��������� ������ ���������. ��������������
������� : fileexists(�������� ������� ����� , ������� �� sysutils) ,
TempDir(������ ��������� ����� windows) , CreateTemporaryFile (��������
���������� ����� �� �����, ���� ��� ���������)

�����������: ������ windows
�����:       KosilkA, gloom@imail.ru, Koenigsberg
Copyright:   1)delphi help 2)delphi units
����:        10 ����� 2004 �.
***************************************************** }

unit UnitCompareFiles;

interface

uses Windows,SysUtils;

const MAX_PATH = 1024;

    function TempDir: string;
    function FileExists(const FileName: pchar): Boolean;
    function CreateTemporaryFile(FileName: string): string;
    function CompareFiles(File1, File2: string; CreateTempFile: Boolean): Boolean;

implementation


function TempDir: string;
{������� ���������� ���� � ����� ��������� ������}
var
  Dir: array[0..MAX_PATH - 1] of char;
begin
  GetTempPath(SizeOf(Dir), Dir);
  Result := Dir;
end;

function FileExists(const FileName: pchar): Boolean;
{������� �������� ������� ����� , ���� ����� �� ������ sysutils.
�� ������ ������� , ����� � ��� ����������� ����� �������� �����,
����� ���� �� ��� ��� �������� �������� api-���� OpenFile(filename,
_Ofstruct,OF_EXIST), �� � �� ���� ��������� ..
��� ���� ���� ��������� �������� ��� ? :-)}

  function FileAge(const FileName: pchar): Integer;
  var
    Handle: THandle;
    FindData: TWin32FindData;
    LocalFileTime: TFileTime;
  type
    LongRec = packed record
      case Integer of
        0: (Lo, Hi: Word);
        1: (Words: array[0..1] of Word);
        2: (Bytes: array[0..3] of Byte);
    end;
  begin
    Handle := FindFirstFile(PChar(FileName), FindData);
    if Handle <> INVALID_HANDLE_VALUE then
    begin
      Windows.FindClose(Handle);
      if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
      begin
        FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
        if FileTimeToDosDateTime(LocalFileTime, LongRec(Result).Hi,
          LongRec(Result).Lo) then
          Exit;
      end;
    end;
    Result := -1;
  end;
begin
  result := false;
  if filename = '' then
    exit;
  Result := FileAge(FileName) <> -1;
end;

function CreateTemporaryFile(FileName: string): string;
{ �������� ��������� ����� ������������ ������ (� ����� Temp),
����� ������������ � �������� ��� ������. ����.
���������� ��� ���������������� �����.}
const
  S: string = '_QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm1234567890';
var
  i, N: integer;
  X: string;
label
  A;
begin
  Randomize;
  A:
  X := '';
  for i := 0 to 7 do {���������� ��� ����� ������ 8 ������}
  begin
    N := Random(Length(S) + 1);
    if N = 0 then
      goto A; {���� ��������� �� goto. ������� ��� ��� ��������� :-)))}
    X := X + S[N];
  end;
  X := TempDir + X + '.tmp';
  if FileExists(pchar(X)) = true then
    goto a
  else
  begin
    if CopyFile(pchar(FileName), pchar(X), true) = true then
      Result := X
    else
      Result := '';
  end;
end;

///////////////////////////////////////////////////////////////////////////
{���������� ������� ���������: }

function CompareFiles(File1, File2: string; CreateTempFile: Boolean): Boolean;
{CreateTempFile -�������� ������ , ����� �� ���������� ������������ ����� ��� ���.
������� ��� ��������� ������, ���� ����, � �������, �������� ���������� exe}
var
  F1, F2: file;
  B1, B2: array[0..127] of Char;
  i1, i2: Integer;
begin
  Result := false;
  if (FileExists(pchar(File1)) = false) or (FileExists(pchar(File2)) = false)
    then
    Exit; {���� ���� �� ������ ����������� , �� �������}
  if CreateTempfile = true then
    {���� ���� - ������� ��������� ����� � ����� Temp}
  begin
    File1 := CreateTemporaryFile(File1);
    File2 := CreateTemporaryFile(File2);
  end;
  FileSetReadOnly(File1, false);
  FileSetReadOnly(File2, false);
  Assign(F1, File1);
  Assign(F2, File2);
  Reset(f1, 1);
  Reset(f2, 1);
  if FileSize(f1) <> FileSize(f2) then
    {���� ������� ������ �� ��������� , �� ���(�����) � ����� ������ �� ���������}
  begin
    CloseFile(F1);
    CloseFile(F2);
    if CreateTempFile = true then
    begin
      DeleteFile(pchar(File1)); {������� ����� �� �����}
      DeleteFile(pchar(File2));
    end;
    Exit;
  end;
  repeat
    ZeroMemory(@B1,SizeOf(B1));
    ZeroMemory(@B2,SizeOf(B2));
    {��������� �������� ���� ���� �� ���������� :}
    BlockRead(F1, B1, SizeOf(B1), i1);
    BlockRead(F2, B2, SizeOf(B2), i2);
    {: ������ ������ � ���������� �����. }

    {��� ������ ��������� ��� ������������� ����� , ��� �� ������� ,result:=false}
    if B1 <> B2 then
    begin
      Result := false;
      CloseFile(F1);
      CloseFile(F2);
      if CreateTempFile = true then
      begin
        DeleteFile(pchar(File1));
        DeleteFile(pchar(File2));
      end;
      Exit;
    end
    else
      Result := true;
  until EoF(F2); {����� �����}
  CloseFile(F1);
  CloseFile(F2);
  if CreateTempFile = true then
    {���� �� ��������� ��������� �����, �� �� ����� ������� :}
  begin
    DeleteFile(pchar(File1));
    DeleteFile(pchar(File2));
  end;
end;
end.
