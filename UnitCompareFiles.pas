{ **** UBPFD *********** by delphibase.endimus.com ****
>> Сравнение двух файлов по содержимому не используя TMemoryStream
(используется только модуль windows)

Позволяет сравнить два файла по содержимому. Если есть отличия -
выдает false, если файлы одинаковы - true. Цель написания данной функции -
избежать использования дополнительных модулей delphi , таких как sysutils ,
classes , если вы хотите сократить размер программы. Дополнительные
функции : fileexists(проверка наличия файла , выдрано из sysutils) ,
TempDir(узнаем временную папку windows) , CreateTemporaryFile (создание
временного файла на диске, если это требуется)

Зависимости: только windows
Автор:       KosilkA, gloom@imail.ru, Koenigsberg
Copyright:   1)delphi help 2)delphi units
Дата:        10 марта 2004 г.
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
{функция возвращает путь к папке временных файлов}
var
  Dir: array[0..MAX_PATH - 1] of char;
begin
  GetTempPath(SizeOf(Dir), Dir);
  Result := Dir;
end;

function FileExists(const FileName: pchar): Boolean;
{функция проверки наличия файла , была взята из модуля sysutils.
Не совсем понимаю , зачем в ней проверяется время создания файла,
можно было бы все эти навороты заменить api-шной OpenFile(filename,
_Ofstruct,OF_EXIST), но я не стал рисковать ..
все таки ведь неспроста написали так ? :-)}

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
{ создание временной копии сравниваемых файлов (в папке Temp),
можно использовать и отдельно для собств. нужд.
Возвращает имя свежеиспеченного файла.}
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
  for i := 0 to 7 do {генерируем имя файла длиной 8 знаков}
  begin
    N := Random(Length(S) + 1);
    if N = 0 then
      goto A; {дико извиняюсь за goto. говорят что это ламерство :-)))}
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
{Собственно функция сравнения: }

function CompareFiles(File1, File2: string; CreateTempFile: Boolean): Boolean;
{CreateTempFile -параметр задает , стоит ли копировать сравниваемые файлы или нет.
Сделано для избежания ошибок, если файл, к примеру, является запущенным exe}
var
  F1, F2: file;
  B1, B2: array[0..127] of Char;
  i1, i2: Integer;
begin
  Result := false;
  if (FileExists(pchar(File1)) = false) or (FileExists(pchar(File2)) = false)
    then
    Exit; {если один из файлов отсутствует , то выходим}
  if CreateTempfile = true then
    {если надо - создаем временные копии в папке Temp}
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
    {если размеры файлов не совпадают , то они(файлы) в любом случае не идентичны}
  begin
    CloseFile(F1);
    CloseFile(F2);
    if CreateTempFile = true then
    begin
      DeleteFile(pchar(File1)); {убираем мусор за собой}
      DeleteFile(pchar(File2));
    end;
    Exit;
  end;
  repeat
    ZeroMemory(@B1,SizeOf(B1));
    ZeroMemory(@B2,SizeOf(B2));
    {повторяем операции пока файл не закончится :}
    BlockRead(F1, B1, SizeOf(B1), i1);
    BlockRead(F2, B2, SizeOf(B2), i2);
    {: блочно читаем и сравниваем блоки. }

    {как только попадутся два различающихся блока , тут же выходим ,result:=false}
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
  until EoF(F2); {конец файла}
  CloseFile(F1);
  CloseFile(F2);
  if CreateTempFile = true then
    {если мы создавали временные копии, то их нужно удалить :}
  begin
    DeleteFile(pchar(File1));
    DeleteFile(pchar(File2));
  end;
end;
end.
