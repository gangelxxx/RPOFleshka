unit UnitReg;

interface
 uses Registry;

 const
   HKEY_LOCAL_MACHINE    = LongWord($80000002);

 const
     /// Ключи
   KeyPathFile = 'PathFile';
   KeyOptions = 'Options';

     /// Переменныйе
   vrPathApp =         'PathApp';
   vrSaveEmailAdress = 'SaveEmailAdress';
   vrSaveUserIndex =   'SaveUserIndex';
   vrPathServer =      'PathServer';

   
  function GetPath(par: string): string;

   // SaveEmailAdress - Временный адрес недавно используешийся
  function GetRegStr(Key: string; Par: string): string;
  function SetRegStr(Key: string; Par: string; str: string): string;


implementation

function GetPath(par: string): string;
var Reg: TRegistry;
begin
 Result:= '';
 Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\SOFTWARE\PPP\PathFile', True) then
   begin
      Result:= Reg.ReadString(par);

      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;


function  GetRegStr(Key: string; Par: string): string;
var Reg: TRegistry;
begin
 Result:= '';
 Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\SOFTWARE\PPP\'+ Key, True) then
   begin
      Result:= Reg.ReadString(par);

      Reg.CloseKey;
    end
     else
      Result:= '1';
  finally
    Reg.Free;
  end;
end;


function SetRegStr(Key: string; Par: string; str: string): string;
var Reg: TRegistry;
begin
 Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\SOFTWARE\PPP\'+ Key, True) then
   begin
      Reg.WriteString(Par, str);
      Reg.CloseKey;
   end
    else
     Result:= '1';
     
  finally
    Reg.Free;
  end;
end;


end.
