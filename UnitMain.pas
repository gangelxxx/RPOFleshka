{
  ������� ������ �������������� ������ ���

  ���� ���������� �������������� 20.12.2007
}
unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, QProgBar, Grids, Calendar, DateUtils,
  IniFiles, UnitViewDir,UnitCompareFiles,UnitSpisRPO,D2XXUnit, UnitEjectUsb,
  ShellApi,UnitMessageUpdate,UnitMessageOk,UnitMessageProgrammer;
type
        TResult = integer;
        TComp = (
                 Winpost,         //Winpost
                 Regpost,         //Regpost
                 No,              //�� ���
                 Programmer,      //���� �
                 SPBT             //����
                );

  const NSprav = 7;
        Sprav: array [1..7] of string = (           //����� ������������ SPBT
                                         'trfd.dbf',
                                         'trfg.dbf',
                                         'trft.dbf',
                                         'const.dbf',
                                         'fkl.dbf',
                                         'lkl.dbf',
                                         'tarif.dbf'
                                        );


type

  RInfo = record  { ��������� ��������������� }
    PathFlehka,             // ���� � �����
    FailIfentif,            // ���� � ����� �����
    NameComputer,           // ��� ���������
    PathOPStoFlesh: string; // ���������� OPS �� �����

    case Comp: TComp of
       Winpost:      (     // Winpost
                        DateStart: string [10];             // ���� ���������� ����� ���
                        DateEnd: string[10];                // ���� ����� ������� ����� ���
                        FileExportRPO: string[254];         // ���� �������� ��� ������ ������ � �������� PathWinpost
                        PathWinpost: string[254];           // ��� ����� WinPost
                        IndexOPS: string[10];               // ������ ��� � ������� ����� ���
                        NameOPS: string[254];               // �������� ��� � ������� ����� ���
                        Export_folder: string[254];         // ���. ���
                        Export_folder_Archiv : string[254]; // ���������� ������ ���
                        FGibrid: string[3];                 // ���� ��������� ���������
                     );
       Regpost:      (     //Regpost
                        PathRegpost: string[254];  // ���������� ����������� � Regpost
                     );
       No:           (     //cNo
                     );
       Programmer:   (     //cProgrammer
                     );
       SPBT:         (     //cSPBT
                        PathSPBT: string[254];  // ���������� ������������ ��������� �� ����
                     );
  end;


  TFormMain = class(TForm)
        { Var }
    ListBox1: TListBox;
    QProgressBar1: TQProgressBar;
    TimerExportRPO: TTimer;
    Calendar1: TCalendar;
    TimerAppRun: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure TimerAppRunTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
        { ������� }
    procedure TimerExportRPOTimer(Sender: TObject);
        { ��������� ListBox }
    procedure ListBox1MeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    { Private var }
    QPSnak1: integer;   // ����� ����� ��������� ��������� ���� ������
    Bit:  TBitmap;      // ���. ����� ��������� 16*16
    Bit0: TBitmap;      // ���. ����            16*16
    Bit1: TBitmap;      // ���. �������         16*16
    Bit2: TBitmap;      // ���. ������          16*16
    Bit3: TBitmap;      // ���. ������.         16*16
    Bit4: TBitmap;      // ���. ������.         16*16
    ItemIndex: integer; // ������ � ListBox ��������������� ��������
    FProgrammer,           // ����������� � �����������
    FGibgidMsg: boolean;
    { Private Procedure }
       { ����� ��������� }
    procedure OkItems(MillSek: integer); overload;
    procedure OkItems(FileName: string; MillSek: integer; LineRPO: word;vData: string); overload;
    procedure OkItems; overload;
    procedure ClockItems(str: string);
    procedure ErrorItems(str: string);
    procedure InfoItems(str: string);
    procedure PunktItems(str: string);
    procedure ClearItems;
    procedure BegLogFiles;
    procedure AddLogFiles(str: String);
    procedure EndLogFiles;
    procedure ForceDirectoryInfo(Dir: String);
       { ������� ��� }
    function  ExportRPO(Date: TDate; Info: RInfo): boolean;
    procedure EditExportIni(Date: TDate; Today: boolean; Info: RInfo);
    function  ExportFullRPO(Info: RInfo): boolean;
       { ������ � Regpost }
    function  ImportRegpost(Info: RInfo): boolean;
    function  EmptyFolderRPO(Path: String): boolean;
    function  CopyToRegpost(FormPath, ToPath: string): boolean;
       { ��������� �������� }
    function  CopyGibridDisk(Info: RInfo): boolean;
       { SPBT }
    function  CopySpravSPBT(FormPath, ToPath: string): boolean;
       { ��������� }
    procedure NextDay;
    procedure SetCalendar(vDate: TDate);
       { ������ � ������� ��� }
    function NullRPO(Name: string): boolean;
    function CountStrRPO(Name: string): integer;
    function DateRPO(Name: string): TDate;
    function SearchRPOtoDate(vDate: TDate; Info: RInfo): string;
    function SearchRPOtoIndex(index: integer; Info: RInfo): string;
    function FileRPO(name: string; IndexOPS: string): boolean;
    function CopyAllFilesRPO(FromDir, ToDir, IndexOPS: string): boolean;
    function DeleAllFiles(ToDir: string): boolean;
    function DeleNULLRPOFiles(ToDir, IndexOPS: string): boolean;
    function EmptyFolder(Path: String): boolean;
    function WindowsCopyFile(FromFile, ToDir: String; ShowInfo: boolean): boolean;
       { ����������� � ���� ���� }
    function MainInfo(var Info: RInfo):boolean;
    function SaveINIDateEnd(Info: RInfo): boolean;
    function SaveINI_FGibrid(Info: RInfo): boolean;
    function SaveINI_FGibridAllYes(Info: RInfo): boolean;
    function CreateSpisRPO(BeginDate, EndDate: TDate; IndexOPS: string): boolean;
    function ExixstsComp(var Info: RInfo): boolean;
    function WinpostCall(Info: RInfo): boolean;
    function RegpostCall(Info: RInfo): boolean;
       { �������� INI ������ }
    function FComp(NameComputer: string): TComp;
    function ErrorLoadSection(Str, Sect, FileInfo: string): boolean;
    function LoadINI(path: string; var Info: RInfo): boolean;
    function LoadINI_Winpost   (path: string; var Info: RInfo): boolean;
    function LoadINI_Regpost   (path: string; var Info: RInfo): boolean;
    function LoadINI_SPBT      (path: string; var Info: RInfo): boolean;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}



procedure TFormMain.FormCreate(Sender: TObject);
begin  { ����������� ����� }
  { ���������������������� }
  QPSnak1:= 1;
  FProgrammer:= false;
  FGibgidMsg:=  false;
  Application.Title:= '������� ���';
  { ��������� ������� ��� ListBox �� res �����}
  Bit := TBitmap.Create;
  Bit.Handle:= LoadBitmap(HInstance,'CLEARPAGE');

  Bit0 := TBitmap.Create;
  Bit0.Handle:= LoadBitmap(HInstance,'CLOCK');

  Bit1 := TBitmap.Create;
  Bit1.Handle:= LoadBitmap(HInstance,'OK');

  Bit2 := TBitmap.Create;
  Bit2.Handle:= LoadBitmap(HInstance,'ERROR');

  Bit3 := TBitmap.Create;
  Bit3.Handle:= LoadBitmap(HInstance,'INFO');

  Bit4 := TBitmap.Create;
  Bit4.Handle:= LoadBitmap(HInstance,'PUNKT');
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin { �� ����������� ����� }
  FreeSpisRPO;
  if FProgrammer = false then
    ShellExecute(FindWindow('ProgMan', nil), 'Open', PChar('prSafeEject.exe'), nil, nil, sw_hide);
end;

procedure TFormMain.TimerExportRPOTimer(Sender: TObject);
var  h: HWND;
begin { ������ ��������� ������ �������� ��� }
  QProgressBar1.position:=  QProgressBar1.position + QPSnak1;

  if not ((QProgressBar1.position > 0) and (QProgressBar1.position < 100)) then begin
     QPSnak1:= QPSnak1 * -1;
  end;

      { ������ ������ ���� TfmWaitAutoExport }
  h:= FindWindow('TfmWaitAutoExport',nil);
  if h <> 0 then begin
  if IsWindowVisible(h) then
    ShowWindow(h,SW_HIDE);
  end;

  SendMessage(Application.MainForm.Handle, WM_NCACTIVATE, 1, 0);
end;

procedure TFormMain.TimerAppRunTimer(Sender: TObject);
var s: string;
    Info: RInfo;
    F: boolean;
begin { ������ ������ ������ ��������� �������� ��� }
  TimerAppRun.Enabled:= false;

  BegLogFiles;
  ZeroMemory(@Info, SizeOf(Info));
  Info.Comp:= No;
  //Info.PathFlehka:= 'D:\AngelWork\ProjectDelphi\Flehka\FLECHKA\';
  Info.PathFlehka:= ExtractFileDir(ParamStr(0));
  //Info.PathFlehka:= 'J:\';

  F:= MainInfo(Info);

  if FGibgidMsg = true then
  begin
    FormGibridUpdate:= TFormGibridUpdate.Create(nil);
    FormGibridUpdate.Show;
    while not FormGibridUpdate.CloseOk do
      Application.ProcessMessages;
    FreeAndNil(FormGibridUpdate);
  end;

  EndLogFiles;

  if F = False then
  begin
    ListBox1.ItemIndex:= ListBox1.Items.Count - 1;
    s:= ListBox1.Items.Strings[ListBox1.ItemIndex];
    Delete(s,1,1);

    if (Application.MessageBox(PChar('������:  - ' + s +#13+ #13 +
                                     '��������� ������������'),
                                     '������� ��� �� ����������...',
                                      MB_OK + MB_ICONERROR) = IDOK) then Close;
  end
  else begin
    if FProgrammer then
    begin
      FormProgrammer:= TFormProgrammer.Create(nil);
      FormProgrammer.Show;
      while not FormProgrammer.CloseOk do
        Application.ProcessMessages;
      FreeAndNil(FormProgrammer);
    end;

    if not FProgrammer then
    begin
      FormProgrammOk:= TFormProgrammOk.Create(nil);
      FormProgrammOk.Show;
      while not FormProgrammOk.CloseOk do
        Application.ProcessMessages;
      FreeAndNil(FormProgrammOk);
    end;
  end;
//
  Close;
end;

procedure TFormMain.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  cc: TCanvas;
  s: string;
begin   { ����� ���� �������� ListBox1 - ���������� ������� �������....}
  cc:=(Control as TListBox).Canvas;
  cc.FillRect(rect);

  s:= ListBox1.Items[index];
  if s[1] = '-' then begin
   cc.Draw(Rect.Left+1,Rect.Top,Bit0);
   Delete(s,1,1);
  end
  else
  if s[1] = '+' then begin
   cc.Draw(Rect.Left+1,Rect.Top,Bit1);
   Delete(s,1,1);
  end
  else
  if s[1] = '?' then begin
   cc.Draw(Rect.Left+1,Rect.Top,Bit2);
   Delete(s,1,1);
  end
  else
  if s[1] = '!' then begin
   cc.Draw(Rect.Left+1,Rect.Top,Bit3);
   Delete(s,1,1);
  end
  else
  if s[1] = '*' then begin
   cc.Draw(Rect.Left+1,Rect.Top,Bit4);
   Delete(s,1,1);
  end
  else
   cc.Draw(Rect.Left+1,Rect.Top,Bit);

  cc.TextOut(Rect.Left + 22,Rect.Top,s);
end;

procedure TFormMain.ListBox1MeasureItem(Control: TWinControl; Index: Integer;
  var Height: Integer);
begin
  Height := 16;
end;



                                  {����� ���������}
procedure TFormMain.OkItems(MillSek: integer);
var s: string;
begin  { ���������� ������� ListBox - ��������� - }
  s:= ListBox1.Items[ItemIndex] + '......................�����: ' + IntToStr(Round(MillSek/1000))+' ���.';
  s[1]:= '+';
  ListBox1.Items.Delete(ItemIndex);
  ListBox1.Items.Insert(ItemIndex,s);
  ListBox1.ItemIndex:= ListBox1.Items.Count-1;
end;

procedure TFormMain.OkItems(FileName: string; MillSek: integer; LineRPO: word; vData: string);
var s: string;
begin  { ���������� ������� ListBox - ��������� - }
  if LineRPO <> 0 then
   s:= '  ����: ' + FileName + ' �� ����: '+  vData +' �����: '+ IntToStr(LineRPO) +'...�����: ' + IntToStr(Round(MillSek/1000))+' ���.'
  else
   s:= '  ���� �� ����: '+  vData +' !!������!! '+'...�����: ' + IntToStr(Round(MillSek/1000))+' ���.';

  s[1]:= '+';
  ListBox1.Items.Delete(ItemIndex);
  ListBox1.Items.Insert(ItemIndex,s);
  ListBox1.ItemIndex:= ListBox1.Items.Count-1;
end;

procedure TFormMain.OkItems;
var s: string;
begin  { ���������� ������� ListBox - ��������� - }
  s:= ListBox1.Items[ItemIndex];
  s[1]:= '+';
  ListBox1.Items.Delete(ItemIndex);
  ListBox1.Items.Insert(ItemIndex,s);
  ListBox1.ItemIndex:= ListBox1.Items.Count-1;
end;

procedure TFormMain.ClockItems(str: string);
begin  { ���������� ������� ListBox - �� ���. - }
  str:= '-'+str;
  ListBox1.Items.Add(str);
  ItemIndex:= ListBox1.Items.Count-1;
  ListBox1.ItemIndex:= ListBox1.Items.Count-1;
  AddLogFiles(str);
end;

procedure TFormMain.ErrorItems(str: string);
begin { ���������� ������� ListBox - ������ - }
  str:= '?'+str;
  ListBox1.Items.Add(str);
  ItemIndex:= ListBox1.Items.Count-1;
  ListBox1.ItemIndex:= ListBox1.Items.Count-1;
  AddLogFiles(str);
end;

procedure TFormMain.InfoItems(str: string);
begin { ���������� ������� ListBox - ���������� - }
  str:= '!'+str;
  ListBox1.Items.Add(str);
  ItemIndex:= ListBox1.Items.Count-1;
  ListBox1.ItemIndex:= ListBox1.Items.Count-1;
  AddLogFiles(str);
end;

procedure TFormMain.PunktItems(str: string);
begin  { ���������� ������� ListBox - ����� - }
  str:= '*'+str;
  ListBox1.Items.Add(str);
  ItemIndex:= ListBox1.Items.Count-1;
  ListBox1.ItemIndex:= ListBox1.Items.Count-1;
  AddLogFiles(str);
end;

procedure TFormMain.ClearItems;
begin  { ���������� ������� ListBox - ������ ������ - }
  ListBox1.Items.Add(' ');
  ItemIndex:= ListBox1.Items.Count-1;
  ListBox1.ItemIndex:= ListBox1.Items.Count-1;
  AddLogFiles('');
end;

procedure TFormMain.BegLogFiles;
var F: TextFile;
    Path: string;
begin  {������ ������ ������ � ��� ���� }
  Path:= ExtractFileDir(ParamStr(0)) + '\log.txt';
  try
  AssignFile(F,Path);
  if not FileExists(Pchar(Path)) then
   Rewrite(F)
  else
   Append(F);
   Writeln(F,'');
   Writeln(F,'<<<<__BEG--------------------------------------------------------------------------------------------------------------------------------------------------BEG__>>>>');
   Writeln(F,'  | '+'����: '+ DateToStr(Date)+ '  �����: ' + TimeToStr(Time));
  finally
   CloseFile(F);
  end;
end;

procedure TFormMain.AddLogFiles(str: String);
var F: TextFile;
    Path: string;
begin  { ������ ������ � ��� ���� }
  Path:= ExtractFileDir(ParamStr(0)) + '\log.txt';
  try
  AssignFile(F,Path);
  if not FileExists(Pchar(Path)) then
   Rewrite(F)
  else
   Append(F);
   Writeln(F,'  | '+str);
  finally
   CloseFile(F);
  end;
end;

procedure TFormMain.EndLogFiles;
var F: TextFile;
    Path: string;
begin  {����� ������ ������ � ��� ���� }
  Path:= ExtractFileDir(ParamStr(0)) + '\log.txt';
  try
  AssignFile(F,Path);
  if not FileExists(Pchar(Path)) then
   Rewrite(F)
  else
   Append(F);
   Writeln(F,'<<<<__END--------------------------------------------------------------------------------------------------------------------------------------------------END__>>>>');
  finally
   CloseFile(F);
  end;
end;

procedure TFormMain.ForceDirectoryInfo(Dir: String);
begin { ���� ��� ���������� ������� � ������� ��������� }
  if not DirectoryExists(Dir) then
  begin
    ErrorItems('���������� ��� �����������: ' + Dir + ' - �� ���������� - (ForceDirectoryInfo)');
    CreateDir(Dir);
    ErrorItems('���������� ��� �����������: ' + Dir + ' - ������� - (ForceDirectoryInfo)');
  end;
end;



                                   {������� ���}
function TFormMain.ExportRPO(Date: TDate; Info: RInfo): boolean;
var
    StartInfo: TStartupInfo;
    ProcInfo:  TProcessInformation;
    str: string;
    path: string;
begin   { ������� ��� � ������� �� ��������� ������� �������� � WinPostExport.ini }
Result:= false;
if not (Info.Comp = Winpost) then Exit;

EditExportIni(Date,false,Info); // ��������� ���� �������� � WinPostExport.ini

FillChar(StartInfo,SizeOf(StartInfo),#0);
StartInfo.cb:= SizeOf(StartInfo);
StartInfo.dwFlags:= STARTF_USESHOWWINDOW;
StartInfo.wShowWindow:= SW_SHOWNORMAL;
str:= Info.PathWinpost +'\'+Info.FileExportRPO;
path:= Info.PathWinpost;
  if CreateProcess(nil,
                 PChar(str),
                 nil,nil,false,
                 NORMAL_PRIORITY_CLASS,
                 nil,
                 PChar(path),
                 StartInfo,ProcInfo) then
    begin
      TimerExportRPO.Enabled:= true;
      repeat
        if WaitForSingleObject(ProcInfo.hProcess, 0) = WAIT_OBJECT_0 then
        begin
          TimerExportRPO.Enabled:= false;
          QProgressBar1.Position:= 0;
          QPSnak1:= 1;
          break;
        end;
        Application.ProcessMessages;
      until false;
      EditExportIni(Date,true,Info);
      Result:= true;
    end;
end;

procedure TFormMain.EditExportIni(Date: TDate; Today: boolean; Info: RInfo);
var Ini: TIniFile;
begin  { �������������� INI WinPostExport }
  Ini:= TIniFile.Create(Info.PathWinpost + '\WinPostExport.INI');
  try
   if Ini.SectionExists('rpo')
   then
     if Today = true then begin
       Ini.WriteString('rpo',':d1','''today''');
       Ini.WriteString('rpo',':d2','''today''');
     end else begin
       Ini.WriteString('rpo',':d1',''''+DateToStr(Date)+'''');
       Ini.WriteString('rpo',':d2',''''+DateToStr(Date)+'''');
     end;
  finally
     FreeAndNil(Ini);
  end;
end;

function TFormMain.ExportFullRPO(Info: RInfo): boolean;
var R: RSpisRPO;
    I,N,BR: integer;
    t: Cardinal;
    NameF: string;
begin  {����������� �� ������ ��� � �������������� ��� �� ��� ����}
     N:= CountRPO + 1;
     I:= 1;
     BR:= 1;
     Result:= true;
   while I <> N do begin
     t:= GetTickCount; //�������� �����
     R:= GetFilePROtoIndex(I);
     ClockItems('������� ��� - ����: ' + DateToStr(R.FileData));

     if not ExportRPO(R.FileData,Info) then begin
       ErrorItems('������ ������� �������� �������� ��������� WinPostExport');
       Result:= false;
       Exit;
     end;

     NameF:= SearchRPOtoIndex(I, Info);

     if NameF = 'over' then begin
       ErrorItems('� �������� ��� ������������ ������ �����');
       Result:= false;
       Exit;
     end;

     if NameF <> 'Error' then
     begin
       if NameF = 'Empty' then
         OkItems(NameF,GetTickCount - t, 0,DateToStr(R.FileData))
       else
         OkItems(NameF,GetTickCount - t, CountStrRPO(NameF),DateToStr(R.FileData));
       Inc(I);
     end
      else
       begin
        if BR <> 3 then begin
           ErrorItems('���� ��� �� �������������... ������');
           Inc(BR);
        end else begin
           ErrorItems('������� ������ � ���� �� ��� ���������� ��� 3 ����... ��������� ������������');
           Result:= false;
           Break;
        end;
       end;
  end;
end;



                                   {������ � Regpost}
function TFormMain.ImportRegpost(Info: RInfo): boolean;
var I: RInfo;
    EFolder:  TEnumFolder;
    Ini: TIniFile;
begin { ������������ � Regpost
          1. ����������� �� ���������
          2. ���� ����� Info ����� ������� � ������� RPO
          3. ���� ����� ��� ��� ����� �����������
             (65907001.02K) - ���������
             (65907001.02F) - ���
          4. ���� ����� ����� ��������
          5. ������ ����� �����������}
  Result:= false;
  EFolder:= TEnumFolder.Create(Info.PathFlehka);
  try
      EFolder.First;
      while not EFolder.Eof do
      begin
       if (EFolder.SR.Attr and faDirectory) = 0 then
       if (EFolder.SR.Attr and faHidden) = 0 then
       begin
         if ExtractFileName(EFolder.AbsPath) = 'info.ini' then
         begin
           ZeroMemory(@I, SizeOf(I));
           I.Comp:= No;

           Ini:= TIniFile.Create(EFolder.AbsPath);
           try
             if Ini.SectionExists('Info')
             then BEGIN
               I.NameComputer:= Ini.ReadString('Info','NameComputer','nou');
               if not ErrorLoadSection(I.NameComputer,'NameComputer',EFolder.AbsPath) then Exit;

               if I.NameComputer = 'Winpost' then
               begin
                 I.Comp:= Winpost;

                 I.NameOPS:= Ini.ReadString('Info','NameOPS','nou');
                 if not ErrorLoadSection(I.NameOPS, 'NameOPS', EFolder.AbsPath) then Exit;
               end;
             end;
           finally
             FreeAndNil(Ini);
           end;

           if I.Comp = Winpost then
           begin
                PunktItems('���: ' + I.NameOPS);
                OkItems;

                if EmptyFolderRPO(ExtractFilePath(EFolder.AbsPath)+ 'Rpo') then
                 InfoItems('������ ��� ���')
                else
                 CopyToRegpost(ExtractFilePath(EFolder.AbsPath)+ 'Rpo', Info.PathRegpost);

                ClearItems;
           end;
         end;
       end;
       EFolder.Next;
      end;
  finally
    FreeAndNil(EFolder);
  end;
  Result:= true;
end;

function TFormMain.EmptyFolderRPO(Path: String): boolean;
 var EFolder:  TEnumFolder;
     str: String;
begin { ��������� ��� ������� � ��� �� ����� �� ���� }
  Result:= false;
  EFolder:= TEnumFolder.Create(Path);
  try
      EFolder.First;
      while not EFolder.Eof do
      begin
       if (EFolder.SR.Attr and faDirectory) = 0 then
       if (EFolder.SR.Attr and faHidden) = 0 then
       begin
         str:= EFolder.AbsPath;
         if str[Length(str)] = 'F' then Exit;
       end;
       EFolder.Next;
      end;
  finally
    FreeAndNil(EFolder);
  end;
  Result:= true;
end;

function TFormMain.EmptyFolder(Path: String): boolean;
 var EFolder:  TEnumFolder;
begin { ��������� ��� ������� ���� }
  Result:= false;
  ForceDirectoryInfo(Path);
  EFolder:= TEnumFolder.Create(Path);
  try
      EFolder.First;
      while not EFolder.Eof do
      begin
       if (EFolder.SR.Attr and faDirectory) = 0 then
       if (EFolder.SR.Attr and faHidden) = 0 then
       begin
         Exit;
       end;
       EFolder.Next;
      end;
  finally
    FreeAndNil(EFolder);
  end;
  Result:= true;
end;

function TFormMain.CopyToRegpost(FormPath, ToPath: string): boolean;
var str: string;
    EFolderCopy:  TEnumFolder;
 begin { �������� ����� � ������ ����� }
  Result:= false;
  EFolderCopy:= TEnumFolder.Create(FormPath);
  try
      EFolderCopy.First;
      while not EFolderCopy.Eof do
      begin
       if (EFolderCopy.SR.Attr and faDirectory) = 0 then
       if (EFolderCopy.SR.Attr and faHidden) = 0 then
       begin
         str:= EFolderCopy.AbsPath;
         str:= str[Length(str)];
         if str = 'F' then begin
           if not WindowsCopyFile(EFolderCopy.AbsPath, ToPath, False) then Exit;
           str:= EFolderCopy.AbsPath;
           str[Length(str)]:= 'K';
           RenameFile(EFolderCopy.AbsPath,str);
           PunktItems('����: ' + ExtractFileName(EFolderCopy.AbsPath) +
                      ' | �������: '+IntToStr(CountStrRPO(str)) +
                      ' | ���� ���: ' + DateToStr(DateRPO(str)));
         end;
       end;
       EFolderCopy.Next;
      end;
  finally
    FreeAndNil(EFolderCopy);
  end;
  Result:= true;
end;



                                    {��������� ��������}
function  TFormMain.CopyGibridDisk(Info: RInfo): boolean;
var EnumFolder: TEnumFolder;
    FromPath, ToPath: String;
    I: RInfo;
begin { �������� ����������� ���� ������������ ������. ��������� �� ���� ��� }
  Result:= False;

  FromPath:= Info.PathFlehka;
  ToPath:= ExtractFileDrive(Info.PathWinpost)+ '\��������� ��������';

  ForceDirectoryInfo(ToPath);

  EnumFolder:= TEnumFolder.Create(FromPath);
  try
    EnumFolder.First;

    while not EnumFolder.Eof do
    begin
     if (EnumFolder.SR.Attr and faDirectory) = 0 then
     if (EnumFolder.SR.Attr and faHidden) = 0 then
     begin
       if ExtractFileName(EnumFolder.AbsPath) = 'info.ini' then
            LoadINI(EnumFolder.AbsPath,I);


       if I.Comp = SPBT then begin
         FromPath:= I.PathOPStoFlesh;
         break;
       end;
     end;
     EnumFolder.Next;
    end;
  finally
    EnumFolder.Free;
  end;

  if I.Comp = SPBT then begin
    InfoItems('���������� ���������� ��������� ���������');
    OkItems;

    if not CopySpravSPBT(FromPath, ToPath) then Exit;

    InfoItems('����� ������������ � �������: ' + ToPath);
    OkItems;
    InfoItems('�� �������� ������� ������ ������������');
    OkItems;
    Result:= True;
  end;
end;



                                    { SPBT }
function TFormMain.CopySpravSPBT(FormPath, ToPath: string): boolean;

  function CopyFFlech(SearchFile: String): boolean;
  var EnumFolder: TEnumFolder;
      str: string;
  begin { ����� ����� ���� ������ �� �������� }
    Result:= false;
    EnumFolder:= TEnumFolder.Create(FormPath);
    try
     EnumFolder.First;
    while not EnumFolder.Eof do
    begin
      if (EnumFolder.SR.Attr and faDirectory) = 0 then
      if (EnumFolder.SR.Attr and faHidden) = 0 then
      begin
        str:= ExtractFileName(EnumFolder.Abspath);
        if SearchFile = str then
        begin
          if not WindowsCopyFile(EnumFolder.Abspath, ToPath, True) then Exit;
          Result:= true;
          Break;
        end;
      end;
      EnumFolder.Next;
    end;

    finally
      EnumFolder.Free;
    end;
  end;

var I: Integer;
begin { �������� ����������� ���� ������ � �������� SPBT}
  Result:= false;
  ForceDirectoryInfo(FormPath);
  ForceDirectoryInfo(ToPath);

  for I := 1 to NSprav do
    if not CopyFFlech(Sprav[I]) then
    begin
      ErrorItems('�� ������ ���� �����������: ' + Sprav[I]);
      break;
    end;

  if I = NSprav + 1 then
    Result:= true;
end;



                                    {���������}
procedure TFormMain.NextDay;

procedure NextMonth;
begin
  if Calendar1.Month = 12 then
  begin
    Calendar1.Day:= 1;
    Calendar1.Month:= 1;
    Calendar1.Year:= Calendar1.Year + 1;
  end
  else begin
    Calendar1.Day:= 1;
    Calendar1.Month:= Calendar1.Month + 1;
  end;
end;

var d: integer;
begin { ������� �� ��������� ���� ��������� }
  d:= Calendar1.Day;
  Inc(d);
  Calendar1.Day:= d;

  if d <> Calendar1.Day then
    NextMonth;
end;

procedure TFormMain.SetCalendar(vDate: TDate);
begin { ���������� ���� �� ��������� }
  Calendar1.Year:= YearOf(vDate);
  Calendar1.Month:= MonthOf(vDate);
  Calendar1.Day:= DayOf(vDate);
end;



                                   { ������ � ������� ��� }
function TFormMain.NullRPO(Name: string): boolean;
var str: TStringList;
begin { �������� ����� ��� �� ����������� ��� }
  str:= TStringList.Create;
  Result:= true;
  try
    str.LoadFromFile(Name);
    if str.Count > 1 then
      Result:= false;
  finally
    FreeAndNil(str);
  end;
end;

function TFormMain.CountStrRPO(Name: string): integer;
var str: TStringList;
begin { ������� ����� � ����� ��� }
  str:= TStringList.Create;
  Result:= 0;
  try
    str.LoadFromFile(Name);
    if str.Count > 1 then
      Result:= str.Count-1;
  finally
    FreeAndNil(str);
  end;
end;

function TFormMain.DateRPO(Name: string): TDate;

      function GetDateStr(txt: string): TDate;
      var n,k: integer;
          sDate: string;
      begin  { ���������� ���� �� ������ ��� }
          for n := 1 to length(txt) - 1 do
           if txt[n] = '|' then break;

          for k := n + 1 to length(txt) - 1 do
            if txt[k] = '|' then break;

          sDate:= copy(txt,n + 1 + 6, 2);                // ����
          sDate:= sDate + '.' + copy(txt,n + 1 + 4, 2);  // �����
          sDate:= sDate + '.' + copy(txt,n + 1, 4);      // ���
          Result:= StrToDate(sDate);
      end;

var str: TStringList;
begin { �������� ����� ��� �� ���� ��� }
  str:= TStringList.Create;
  Result:= EncodeDate(1,1,1);
  try
    str.LoadFromFile(Name);
    if str.Count = 2 then
       Result:= GetDateStr(str.Strings[1])
    else
    if str.Count > 2 then
     if CompareDate(GetDateStr(str.Strings[1]), GetDateStr(str.Strings[str.count-1])) = 0 then
      Result:= GetDateStr(str.Strings[1])
     else
      Result:= EncodeDate(2,2,2);
  finally
    FreeAndNil(str);
  end;
end;

function TFormMain.WindowsCopyFile(FromFile, ToDir: String; ShowInfo: boolean): boolean;
var { ������� ����������� ������ }
  F: TShFileOpStruct;
begin
  Result:= false;
  if not FileExists(PChar(FromFile)) then
  begin
    ErrorItems('����: ' + FromFile + ' - �� ����������');
    Exit;
  end;

  if not DirectoryExists(Todir) then
  begin
    ErrorItems('���������� ��� �����������: ' + Todir + ' - �� ����������');
    CreateDir(Todir);
    ErrorItems('���������� ��� �����������: ' + Todir + ' - �������');
  end;

  F.Wnd := 0;
  F.wFunc := FO_COPY;
  FromFile:=FromFile+#0;
  F.pFrom:=pchar(FromFile);
  ToDir:=ToDir+#0;
  F.pTo:=pchar(ToDir);
  F.fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION;
  result:=ShFileOperation(F) = 0;

  Delete(FromFile,Length(FromFile),1);
  Delete(ToDir,Length(ToDir),1);
  if ShowInfo then
     PunktItems('���������� ����: "' + FromFile + '"    �     "' + ToDir + '"');

  if Result = false then
    ErrorItems('�� ���������� ����: "' + FromFile + '"    �     "' + ToDir + '"');
end;

function TFormMain.FileRPO(name: string; IndexOPS: string): boolean;
begin  { ��������� ��� ����� ��� 659070**.**F }
  Result:= false;
  if Copy(ExtractFileName(name),1,6) = IndexOPS then
   if Copy(ExtractFileExt(name),4,1) = 'F' then
     Result:= true;
end;

function TFormMain.SearchRPOtoDate(vDate: TDate; Info: RInfo): string;
var EFolder:  TEnumFolder;
begin  { ������ ���� ���� ��� �� ���� vDate ������ }
  Result:= '';
  ForceDirectoryInfo(Info.Export_folder);
  EFolder:= TEnumFolder.Create(Info.Export_folder);
  try
      EFolder.First;
      // ��������� ������ ������
      while not EFolder.Eof do
      begin
       if (EFolder.SR.Attr and faDirectory) = 0 then
       if (EFolder.SR.Attr and faHidden) = 0 then
       begin
         if FileRPO(EFolder.AbsPath, Info.IndexOPS) then
          if not NullRPO(EFolder.AbsPath) then
           if CompareDate(DateRPO(EFolder.AbsPath),vDate) = 0 then
          begin
            Result:= EFolder.AbsPath;
            break;
          end;
       end;
       EFolder.Next;
      end;
  finally
    FreeAndNil(EFolder);
  end;
end;

function TFormMain.SearchRPOtoIndex(index: integer; Info: RInfo): string;
var R: RSpisRPO;
    CountFile: integer;
    EFolder:  TEnumFolder;
begin {���������� ������ �� ���� ���}
  R:= GetFilePROtoIndex(index);
  Result:= SearchRPOtoDate(R.FileData, Info);
  CountFile:= 0;

  if Result <> '' then begin
    R:= CreateRecSpisRPO(Result, R.FileData,1,CountStrRPO(Result));
    SetFileRPO(R,Index);
    Exit;  // ������� � �������
  end;

  ForceDirectoryInfo(Info.Export_folder);
  EFolder:= TEnumFolder.Create(Info.Export_folder);
  try
      EFolder.First;
      // ��������� ����������� ������ � ��������
      while not EFolder.Eof do
      begin
       if (EFolder.SR.Attr and faDirectory) = 0 then
       if (EFolder.SR.Attr and faHidden) = 0 then
       begin
         if FileRPO(EFolder.AbsPath, Info.IndexOPS) then
           Inc(CountFile);
       end;
       EFolder.Next;
      end;
  finally
    FreeAndNil(EFolder);
  end;

 if CountFile = index then              // ���� ���. ������ ������� ����� ���� ������
   Result:= 'Empty'
 else
 if CountFile < index then  Result:= 'Error' // ������ ������� �� ����������
 else
 if CountFile > index then  Result:= 'over' // ������ ���� ������� �����
end;

function TFormMain.CopyAllFilesRPO(FromDir, ToDir, IndexOPS: string): boolean;
var EnumFolder: TEnumFolder;
begin { �������� ����������� ���� ������ ��� � �������� }
  Result:= false;
  ForceDirectoryInfo(FromDir);

  EnumFolder:= TEnumFolder.Create(FromDir);
  try
   EnumFolder.First;
  while not EnumFolder.Eof do
  begin
   if (EnumFolder.SR.Attr and faDirectory) = 0 then
   if (EnumFolder.SR.Attr and faHidden) = 0 then
   begin
     if not FileRPO(EnumFolder.AbsPath, IndexOPS) then Exit else
       if not NullRPO(EnumFolder.AbsPath) then
        if not WindowsCopyFile(EnumFolder.Abspath, ToDir, True) then Exit;
   end;
   EnumFolder.Next;
  end;

  finally
    EnumFolder.Free;
  end;
  Result:= true;
end;

function TFormMain.DeleAllFiles(ToDir: string): boolean;
var EnumFolder: TEnumFolder;
begin { �������� �������� ���� ������ � �������� }
  Result:= false;
  ForceDirectoryInfo(ToDir);

  EnumFolder:= TEnumFolder.Create(ToDir);
  try
  EnumFolder.First;
  if EnumFolder.Eof then Exit;

  while not EnumFolder.Eof do
  begin
   if (EnumFolder.SR.Attr and faDirectory) = 0 then
   if (EnumFolder.SR.Attr and faHidden) = 0 then
   begin
     if not DeleteFile(EnumFolder.Abspath) then Exit;
   end;
   EnumFolder.Next;
  end;

  finally
    EnumFolder.Free;
  end;
  Result:= true;

end;

function TFormMain.DeleNULLRPOFiles(ToDir, IndexOPS: string): boolean;
var EnumFolder: TEnumFolder;
begin { �������� �������� ���� ������� ������ ��� � �������� }
  Result:= false;
  ForceDirectoryInfo(ToDir);

  EnumFolder:= TEnumFolder.Create(ToDir,false);
  try
  EnumFolder.First;
  if EnumFolder.Eof then Exit;

  while not EnumFolder.Eof do
  begin
   if (EnumFolder.SR.Attr and faDirectory) = 0 then
   if (EnumFolder.SR.Attr and faHidden) = 0 then
   begin
     if not FileRPO(EnumFolder.AbsPath, IndexOPS) then Exit else
       if NullRPO(EnumFolder.AbsPath) then
        if not DeleteFile(EnumFolder.Abspath) then Exit;
   end;
   EnumFolder.Next;
  end;

  finally
    EnumFolder.Free;
  end;
  Result:= true;

end;



                                    { ����������� � ���� ���� }
function TFormMain.MainInfo(var Info: RInfo): boolean;
begin { �������� ���� � ��� ���������... �������� (������ ��� �����������) }

  Result:= false;
    InfoItems(' - �������������');
      if not ExixstsComp(Info) then begin // ����������� ����� � �������� ������������
        ErrorItems('������ ������������� �����');
        Exit;
      end;

    case Info.Comp of
      Winpost:    begin
                    PunktItems('���: ' + Info.NameOPS);
                    PunktItems('������ ���: '+ Info.IndexOPS);
                    PunktItems('��������: ' + Info.NameComputer);
                    PunktItems('���� ���������� ���������������: ' + Info.DateStart);
                    PunktItems('������� ����: ' + DateToStr(Date));
                    PunktItems('������� �����: ' + TimeToStr(Time));
                    InfoItems(' - ���������� ��������');
                    ClearItems;
                    if not WinpostCall(Info) then Exit;
                  end;
      Regpost:    begin
                    PunktItems('��������: ' + Info.NameComputer);
                    PunktItems('������� ����: ' + DateToStr(Date));
                    PunktItems('������� �����: ' + TimeToStr(Time));
                    InfoItems(' - ���������� ��������');
                    ClearItems;
                    if not RegpostCall(Info) then Exit;
                  end;
      Programmer: begin
                    PunktItems('��������: ' + Info.NameComputer);
                    PunktItems('������� ����: ' + DateToStr(Date));
                    PunktItems('������� �����: ' + TimeToStr(Time));
                    InfoItems(' - ���������� ��������');
                    ClearItems;
                    InfoItems('������ ���������� !!!');
                    FProgrammer:= true;
                  end;
      SPBT:       begin
                     PunktItems('��������: ' + Info.NameComputer);
                     PunktItems('������� ����: ' + DateToStr(Date));
                     PunktItems('������� �����: ' + TimeToStr(Time));
                     InfoItems(' - ���������� ��������');
                     ClearItems;
                     InfoItems('����������� �� ������');
                     ForceDirectoryInfo(Info.PathSPBT);
                     ForceDirectoryInfo(Info.PathOPStoFlesh);
                     if not CopySpravSPBT(Info.PathSPBT,Info.PathOPStoFlesh) then Exit;
                     if not SaveINI_FGibridAllYes(Info) then Exit;
                     InfoItems('����������� ���������');
                  end;
      No:         begin
                    ErrorItems('�������� ������������� ������ �� ������� No');
                    Exit;
                  end;
    end;

   InfoItems(' - ���������� ������');
   OkItems;
   ClearItems;
   Result:= true;
end;

function TFormMain.SaveINIDateEnd(Info: RInfo): boolean;
var Ini: TIniFile;
begin {���������� ���� ��������}
    Result:= false;
//info.ini
    if Info.Comp = Winpost then
    begin
      Ini:= TIniFile.Create(Info.PathOPStoFlesh + '\info.ini');
      try
        if Ini.SectionExists('Info') then
        begin
         Ini.WriteString('Info','DateStart',Info.DateEnd);
         InfoItems('��������� ���� ���������������: ' + Info.DateEnd);
         OkItems;
        end
        else Exit;
      finally
        FreeAndNil(Ini);
      end;
    end;
  Result:= true;
end;

function TFormMain.SaveINI_FGibrid(Info: RInfo): boolean;
var Ini: TIniFile;
begin {��������� ����� � ����������� ������������ ���. ���������}
    Result:= false;
//info.ini
    if Info.Comp = Winpost then
    begin
      Ini:= TIniFile.Create(Info.PathOPStoFlesh + '\info.ini');
      try
        if Ini.SectionExists('Info') then
        begin
         Ini.WriteString('Info','FGibrid',Info.FGibrid);
         if Info.FGibrid = 'Yes' then
           InfoItems('�������� ��� � '+ Info.NameOPS + ' ����� ������ ���������� ' + Info.FGibrid)
         else
           InfoItems('�������� ��� ����������� ����������� � ���������� � ��� ��������� �� ������ �� �����: ' + Info.FGibrid);
         OkItems;
        end
        else Exit;
      finally
        FreeAndNil(Ini);
      end;
    end;
  Result:= true;
end;

function TFormMain.SaveINI_FGibridAllYes(Info: RInfo): boolean;
var EnumFolder: TEnumFolder;
    I: RInfo;
begin { �������� ������ ����� �� ���������� ������������ �� ���� ��� �� ����� }
  Result:= false;
  ForceDirectoryInfo(Info.PathFlehka);

  EnumFolder:= TEnumFolder.Create(Info.PathFlehka);
  try
   EnumFolder.First;
  while not EnumFolder.Eof do
  begin
   if (EnumFolder.SR.Attr and faDirectory) = 0 then
   if (EnumFolder.SR.Attr and faHidden) = 0 then
   begin
     if ExtractFileName(EnumFolder.AbsPath) = 'info.ini' then
       LoadINI(EnumFolder.AbsPath,I);

     if I.Comp = Winpost then
     begin
       I.FGibrid:= 'Yes';
       SaveINI_FGibrid(I);
       ZeroMemory(@I, SizeOf(I));
       I.Comp:= No;
     end;
   end;                      
   EnumFolder.Next;
  end;

  finally
    EnumFolder.Free;
  end;
  Result:= true;
end;

function TFormMain.CreateSpisRPO(BeginDate, EndDate: TDate; IndexOPS: string): boolean;
var  R: RSpisRPO;
begin  {����������� �� ����� �� ������� � ������� ����� ������ ���}
  SetCalendar(BeginDate);
  Result:= true;

  if CompareDate(BeginDate,EndDate) < 0 then
  while CompareDate(Calendar1.CalendarDate,EndDate) <> 0 do begin
     R:= CreateRecSpisRPO(IndexOPS,Calendar1.CalendarDate,-1,-1);
     AddSpisRPO(R);
     PunktItems(IndexOPS+'*.*f....'+DateToStr(Calendar1.CalendarDate));

     NextDay;
  end
   else Result:= false;
end;

function TFormMain.ExixstsComp(var Info: RInfo): boolean;
var EFolder:  TEnumFolder;
    Ini: TIniFile;
    I: RInfo;
begin  {
          0. ����������� �� ��������� ������
          1. ���� ����� � �������� ���� info.ini ����� ��������� ��������� �� info.ini
          2. ���������� � ������ ���� �����
          3. ���� ��������� ����� �������:
               ? ����� 0.
        }
  Result:= false;
  EFolder:= TEnumFolder.Create(Info.PathFlehka);
  try
      EFolder.First;
      while not EFolder.Eof do
      begin
       if (EFolder.SR.Attr and faDirectory) = 0 then
       if (EFolder.SR.Attr and faHidden) = 0 then
       begin
         if ExtractFileName(EFolder.AbsPath) = 'info.ini' then begin

           Ini:= TIniFile.Create(EFolder.AbsPath);
           try
             if Ini.SectionExists('Info')
             then BEGIN
                I.FailIfentif:= Ini.ReadString('Info','FailIfentif','nou');
                if not ErrorLoadSection(I.FailIfentif,'FailIfentif',EFolder.AbsPath) then Exit;

                I.PathOPStoFlesh:= ExtractFileDir(EFolder.AbsPath);
             end
             else begin
               ErrorItems('������ Info �� ������� - (ExixstsComp)');
               Exit;
             end;
           finally
             FreeAndNil(Ini);
           end;

           if CompareFiles(I.PathOPStoFlesh+'\'+ExtractFileName(I.FailIfentif),
                           I.FailIfentif, True) then
           begin
             if not LoadINI(EFolder.AbsPath, I) then Exit;
             Info:= I;
             Result:= true;
             break;
           end;
         end;
       end;
       EFolder.Next;
      end;
  finally
    FreeAndNil(EFolder);
  end;
end;

function TFormMain.WinpostCall(Info: RInfo): boolean;
begin {��������� Winpost}
  Result:= false;

  if Info.FGibrid = 'Yes' then
  if not CopyGibridDisk(Info) then
    ErrorItems('������ ����������� ������������ ��������� ���������')
  else begin
    FGibgidMsg:= true;
    Info.FGibrid:= 'No';
    SaveINI_FGibrid(Info);
  end;

                              {����������� ������ ��� ������ ���}
  ClearItems;
  InfoItems('������� ������ �������������� ������ ���');
  if not CreateSpisRPO(StrToDate(Info.DateStart),StrToDate(Info.DateEnd), Info.IndexOPS) then begin
    ErrorItems('���� ������� �������� ��� ����� (��� ��������� ������ ��������)');
    Exit;
  end;
  InfoItems('������ ������ ��� �����');
  ClearItems;


  if not EmptyFolder(Info.Export_folder) then
    if not DeleAllFiles(Info.Export_folder) then begin
      ErrorItems('����� �� ������� ��: '+Info.Export_folder);
      Exit;
    end;

      InfoItems('������� ������ ���');

      if not ExportFullRPO(Info) then  Exit;       {������� ����� ���}

      InfoItems('������� ������ ��� ��������');
      ClearItems;


  DeleNULLRPOFiles(Info.Export_folder,Info.IndexOPS);  //������ ������ ����� ���
  SaveINIDateEnd(Info);                                       //�������� ���� ���������������

                                                     {����������� �� ����� � � �����}
  if not EmptyFolder(Info.Export_folder) then begin
        InfoItems('����������� �� ������');
        OkItems;
        if not CopyAllFilesRPO(Info.Export_folder, Info.PathOPStoFlesh + '\' + 'Rpo',Info.IndexOPS) then begin
          ErrorItems('����� �� ������������ ��:'+ Info.Export_folder+' � ' + Info.IndexOPS);
          Exit;
        end;

        ClearItems;

        InfoItems('��������� � �����');
        OkItems;
        if not CopyAllFilesRPO(Info.Export_folder, Info.Export_folder_Archiv,Info.IndexOPS) then begin
          ErrorItems('����� �� ������������ ��:'+ Info.Export_folder+' � ' + Info.Export_folder_Archiv);
          Exit;
        end;

        ClearItems;
        if not DeleAllFiles(Info.Export_folder) then begin
          ErrorItems('����� �� ������� ��: '+Info.Export_folder);
          Exit;
        end;

  end else begin
    InfoItems('���������� ������ ��� �����... ���������� ������');
    OkItems;
  end;

  Result:= true;
end;

function TFormMain.RegpostCall(Info: RInfo): boolean;
begin {��������� Regpost}
  Result:= false;

  ClearItems;                              {����������� � Regpost}
  InfoItems('������ � Regpost');
  ClearItems;
  if not ImportRegpost(Info) then
  begin
    ErrorItems('������ � Regpost �� ��������');
    Exit;
  end;
  InfoItems('������ � Regpost ��������');

  Result:= true;
end;




                                    { �������� INI ������ }
function TFormMain.FComp(NameComputer: string): TComp;
begin  { �� ����� ���������� ��� ����� }
  if NameComputer = 'Regpost' then
    Result:= Regpost else
  if NameComputer = 'Programmer' then
    Result:= Programmer else
  if NameComputer = 'SPBT' then
    Result:= SPBT else
  if NameComputer = 'Winpost' then
    Result:= Winpost
  else
    Result:= No;
end;

function TFormMain.ErrorLoadSection(Str, Sect, FileInfo: string): boolean;
begin { ����� ��������� �� ������ �������� ������ }
  Result:= false;
    if Str = 'nou' then begin
      Result:= false;
      ErrorItems('����������� ������ � ������: '+ 'Info - ����������: ' + Sect);
      ErrorItems('����:' + FileInfo);
      Exit;
    end;
  Result:= true;
end;

function TFormMain.LoadINI(path: string; var Info: RInfo): boolean;
var Ini: TIniFile;
begin { �������� Ini ���� � ����������� ���}
    Result:= false;
//info.ini
    Ini:= TIniFile.Create(path);
    try
     if Ini.SectionExists('Info')
     then BEGIN
       Info.NameComputer:= Ini.ReadString('Info','NameComputer','nou');
       if not ErrorLoadSection(Info.NameComputer,'NameComputer',Path) then Exit
       else begin
         case FComp(Info.NameComputer) of
             Regpost:    begin   // Regpost
                           Info.Comp:= Regpost;

                           if not LoadINI_Regpost   (Path, Info) then  begin
                             Info.Comp:= No;
                             Exit;
                           end;
                         end;
             Programmer: begin   // Programmer
                           Info.Comp:= Programmer;
                         end;
             SPBT:       begin   // SPBT
                           Info.Comp:= SPBT;

                           if not LoadINI_SPBT      (Path, Info)then  begin
                             Info.Comp:= No;
                             Exit;
                           end;
                         end;
             Winpost:    begin  // Winpost
                           Info.Comp:= Winpost;

                           if not LoadINI_Winpost   (Path, Info)then begin
                             Info.Comp:= No;
                             Exit;
                           end;
                         end;
             No:         begin
                           Info.Comp:= No;
                           ErrorItems('�� ���������� ��� ����� � ����������: ' + Path);
                           Exit;
                         end;
         end;
       end;
     END;
    finally
       FreeAndNil(Ini);
    end;
    
  Result:= true;
end;

function TFormMain.LoadINI_Regpost(path: string; var Info: RInfo): boolean;
var Ini: TIniFile;
begin { �������� Ini ���� � ����������� Regpost}
  Result:= false;
    Ini:= TIniFile.Create(path);
    try
      Info.PathRegpost:= Ini.ReadString('Info','PathRegpost','nou');
      if not ErrorLoadSection(Info.PathRegpost,'PathRegpost', Path) then Exit;
    finally
     FreeAndNil(Ini);
    end;
  Result:= true;
end;

function TFormMain.LoadINI_SPBT(path: string; var Info: RInfo): boolean;
var Ini: TIniFile;
begin  { �������� Ini ���� � ����������� SPBT }
  Result:= false;
    Ini:= TIniFile.Create(path);
    try
      Info.PathSPBT:= Ini.ReadString('Info','PathSPBT','nou');
      if not ErrorLoadSection(Info.PathSPBT,'PathSPBT', Path) then Exit;
    finally
     FreeAndNil(Ini);
    end;
  Result:= true;
end;

function TFormMain.LoadINI_Winpost(path: string; var Info: RInfo): boolean;
var Ini: TIniFile;
begin  { �������� Ini ���� � ����������� Winpost }
  Result:= false;

    Ini:= TIniFile.Create(path);
    try
     if Ini.SectionExists('Info')
     then BEGIN
       Info.IndexOPS:= Ini.ReadString('Info','IndexOPS','nou');
       if not ErrorLoadSection(Info.IndexOPS, 'IndexOPS', path) then Exit;

       Info.NameOPS:= Ini.ReadString('Info','NameOPS','nou');
       if not ErrorLoadSection(Info.NameOPS, 'NameOPS', path) then Exit;

       Info.DateStart:= Ini.ReadString('Info','DateStart','nou');
       if not ErrorLoadSection(Info.DateStart, 'DateStart', path) then Exit;

       Info.DateEnd:= Ini.ReadString('Info','DateEnd','nou');
       if not ErrorLoadSection(Info.DateEnd, 'DateEnd', path) then Exit
         else
           if Info.DateEnd = 'today' then  Info.DateEnd:= DateToStr(Date);

       Info.FileExportRPO:= Ini.ReadString('Info','FileExportRPO','nou');
       if not ErrorLoadSection(Info.FileExportRPO, 'FileExportRPO', path) then Exit;

       Info.PathWinpost:= Ini.ReadString('Info','PathWinpost','nou');
       if not ErrorLoadSection(Info.PathWinpost, 'PathWinpost', path) then Exit;

       Info.Export_folder_Archiv:= Ini.ReadString('Info','Export_folder_Archiv','nou');
       if not ErrorLoadSection(Info.Export_folder_Archiv, 'Export_folder_Archiv', path) then Exit;

       Info.FGibrid:= Ini.ReadString('Info','FGibrid','nou');
       if not ErrorLoadSection(Info.FGibrid, 'FGibrid', path) then Exit;
     END;
    finally
       FreeAndNil(Ini);
    end;

  //WinPostExport.ini
  if not FileExists(Pchar(Info.PathWinpost + '\WinPostExport.ini')) then
  begin
    ErrorItems('����: ' + Info.PathWinpost + '\WinPostExport.ini' + ' �� ���������� ');
    Exit;
  end;

  Ini:= TIniFile.Create(Info.PathWinpost + '\WinPostExport.ini');
  try
   if Ini.SectionExists('rpo')
   then
     Info.Export_folder:= Ini.ReadString('rpo','Export_folder','nou');
     if not ErrorLoadSection(Info.Export_folder, 'Export_folder', path) then Exit;
  finally
     FreeAndNil(Ini);
  end;

  Result:= true;
end;

end.
