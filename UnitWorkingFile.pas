unit UnitWorkingFile;

interface
 uses ShellApi, SysUtils, Dialogs, UnitViewDir, Windows;

    function WindowsCopyFile(FromFile, ToDir : String) : boolean;
    function ApplicationUseFile(fName: string): boolean;

implementation

function WindowsCopyFile(FromFile, ToDir: String): boolean;
var { Функция копирования файлов (Без проверок) }
  F: TShFileOpStruct;
begin
  Result:= false;
  if not FileExists(FromFile) then Exit;
  if not DirectoryExists(Todir) then Exit;

  F.Wnd := 0;
  F.wFunc := FO_COPY;
  FromFile:=FromFile+#0;
  F.pFrom:=pchar(FromFile);
  ToDir:=ToDir+#0;
  F.pTo:=pchar(ToDir);
  F.fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION;
  result:=ShFileOperation(F) = 0;
end;

function ApplicationUseFile(fName: string): boolean;
var   { Проверка доступа к файлу }
  HFileRes: HFILE;
begin
  Result := false;
  if not FileExists(fName) then exit;
  HFileRes := CreateFile(pchar(fName), GENERIC_READ or GENERIC_WRITE, 0, nil,
    OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  Result := (HFileRes = INVALID_HANDLE_VALUE);
  if not Result then CloseHandle(HFileRes);
end;

end.

