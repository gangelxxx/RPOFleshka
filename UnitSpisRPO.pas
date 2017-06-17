{
  Работа со списком файлов РПО

  Дата редоктирования: 07.12.2007
}
unit UnitSpisRPO;

interface
uses Controls,SysUtils,DateUtils;
type
     PSprisRPO = ^RSpisRPO;
     RSpisRPO = record
       FileName: string;
       FileData: TDate;
       ExportOk: integer;
       FileLine: integer;
       Index: integer;

       next: PSprisRPO;
       first: PSprisRPO;
     end;

     procedure AddSpisRPO(Rec: RSpisRPO);
     procedure FreeSpisRPO;
     function SetFileRPO(Rec: RSpisRPO; Index: Integer): boolean;
     function SearchFileRPO(Rec: RSpisRPO): integer;
     function GetFilePROtoIndex(index: integer): RSpisRPO;
     function GetFileRPO(Rec: RSpisRPO):RSpisRPO;
     function CountRPO: integer;
     function CountFileRPO: integer;

     function CreateRecSpisRPO(vFileName: string;
                               vFileData: TDate;
                               vExportOk: integer;
                               vFileLine: integer):RSpisRPO;


var SpisRPO: PSprisRPO;

implementation

procedure AddSpisRPO(Rec: RSpisRPO);
var P,I: PSprisRPO;
begin  { Добавить данные в список }
  New(P);
  with P^ do begin
  FileName:= Rec.FileName;
  FileData:= Rec.FileData;
  ExportOk:= Rec.ExportOk;
  FileLine:= Rec.FileLine;

  Index:= 1;
  next:= nil;
  first:= nil;
  end;

  if SpisRPO = nil then begin
    SpisRPO:= P;
  end else begin
    I:= SpisRPO;
    while I^.next <> nil do I:= I^.next;
    P^.Index:= I^.Index + 1;
    I^.next:= P;
    P^.first:= I;
  end;
end;

procedure FreeSpisRPO;
var I,P: PSprisRPO;
begin { Удолить список файлов РПО}
  I:= SpisRPO;
  while I <> nil do begin
   P:= I;
   I:= I^.next;

    if I <> nil then
      I^.first:= nil;

   Dispose(P);
  end;
  SpisRPO:= nil;
end;

function SetFileRPO(Rec: RSpisRPO; Index: Integer): boolean;
var I: PSprisRPO;
begin { Найти и вернуть индекс записи }
  I:= SpisRPO;
  Result:= true;
  while I <> nil do begin
   if I^.index = index then
     break
   else
   I:= I^.next;
  end;

  if I <> nil then begin
   with I^ do begin
     FileName:= Rec.FileName;
     FileData:= Rec.FileData;
     ExportOk:= Rec.ExportOk;
     FileLine:= Rec.FileLine;
   end;
  end else Result:= false;
end;

function SearchFileRPO(Rec: RSpisRPO): integer;
var I: PSprisRPO;
begin { Найти и вернуть индекс записи }
  I:= SpisRPO;
  Result:= 0;
  while I <> nil do begin
    if Rec.FileName = I^.FileName then break
    else
    if Rec.FileData = I^.FileData then break
    else
    if Rec.ExportOk = I^.ExportOk then break
    else
    if Rec.FileLine = I^.FileLine then break
    else
    if Rec.Index = I^.Index then
    else
    if I^.next = nil then begin
      Result:= -1;
      break;
    end;

    I:= I^.next;
  end;
  if Result = 0 then Result:= I^.Index;
end;

function GetFilePROtoIndex(index: integer): RSpisRPO;
var I: PSprisRPO;
begin { Найти РПО по индексу }
  I:= SpisRPO;
  while I <> nil do begin
    if I^.index = index then
      break
    else
    I:= I^.next;
  end;
  Result:= CreateRecSpisRPO(I^.FileName,I^.FileData,I^.ExportOk,I^.FileLine);
end;

function GetFileRPO(Rec: RSpisRPO):RSpisRPO;
var I: PSprisRPO;
begin { Найти и вернуть данные }
  I:= SpisRPO;
  while I <> nil do begin
    if Rec.Index = I^.Index then
      break
    else
    I:= I^.next;
  end;
 Result:= CreateRecSpisRPO(I^.FileName,I^.FileData,I^.ExportOk,I^.FileLine);
end;

function CountRPO: integer;
var I: PSprisRPO;
begin { Вернуть номер последнего индекса }
  I:= SpisRPO;
  while I^.next <> nil do I:= I^.next;
  Result:= I^.Index;
end;

function CountFileRPO: integer;
var I: PSprisRPO;
begin { Вернуть колличество фалов в списке }
  I:= SpisRPO;
  Result:= 0;
  while I <> nil do begin
    if I^.ExportOk = 1 then
      Inc(Result)
    else
    I:= I^.next;
  end;
end;

function CreateRecSpisRPO(vFileName: string;
                          vFileData: TDate;
                          vExportOk: integer;
                          vFileLine: integer):RSpisRPO;
begin { Инцелизировать поля записи }
  Result.FileName:= vFileName;
  Result.FileData:= vFileData;
  Result.ExportOk:= vExportOk;
  Result.FileLine:= vFileLine;
  Result.Index:=0;
  Result.next:= nil;
  Result.first:= nil;
end;

begin
 SpisRPO:= nil;
end.
