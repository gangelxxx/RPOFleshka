unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Buttons, ExtCtrls, IniFiles, ShellAPI, ShlObj;

type
  TForm1 = class(TForm)
    Bevel1: TBevel;
    BtnRedOPS: TBitBtn;
    BtnRedRegPost: TBitBtn;
    PanelOPS: TPanel;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    MaskEdit_DataStart: TMaskEdit;
    Label3: TLabel;
    MaskEditDataEndOPS: TMaskEdit;
    MaskEdit_IndexOPS: TMaskEdit;
    Label5: TLabel;
    Label6: TLabel;
    Edit_NameOPS: TEdit;
    Label4: TLabel;
    Label8: TLabel;
    Label7: TLabel;
    Label10: TLabel;
    Edit_PathFileIdentif: TEdit;
    EditPathWinpost: TEdit;
    BtnAddDir2: TButton;
    BtnAddDir3: TButton;
    PanelRegpost: TPanel;
    Label28: TLabel;
    Label29: TLabel;
    Edit8: TEdit;
    Edit9: TEdit;
    Button10: TButton;
    Button11: TButton;
    Edit7: TEdit;
    Label24: TLabel;
    PanelStart: TPanel;
    Label25: TLabel;
    BtnExit: TBitBtn;
    OpenDialog1: TOpenDialog;
    Bevel2: TBevel;
    procedure Button11Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure BtnAddDir3Click(Sender: TObject);
    procedure BtnAddDir2Click(Sender: TObject);
    procedure BtnOKExitClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnRedMainClick(Sender: TObject);
    procedure BtnRedRegPostClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnRedOPSClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
    function TrueParam: boolean;
    function ApplicationPath: string;
    function ChooseFolder(Title: string): string;
    procedure LoadIniRegpost;
    procedure CreateRegpostIni(path: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.BtnExitClick(Sender: TObject);
begin
 Close;
end;

procedure TForm1.BtnOKExitClick(Sender: TObject);
begin
 Close;
end;

procedure TForm1.BtnRedMainClick(Sender: TObject);
begin
  PanelStart.Visible:= false;
  PanelOPS.Visible:= false;
  PanelRegpost.Visible:= false;
end;

procedure TForm1.BtnRedOPSClick(Sender: TObject);
begin
  PanelStart.Visible:= false;
  PanelOPS.Visible:= true;
  PanelRegpost.Visible:= false;
end;

procedure TForm1.BtnRedRegPostClick(Sender: TObject);
begin
  PanelStart.Visible:= false;
  PanelOPS.Visible:= false;
  PanelRegpost.Visible:= true;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  Edit8.Text:= ChooseFolder('Укажите каталог...');
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Edit9.Text:= OpenDialog1.FileName;
end;

procedure TForm1.BtnAddDir2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Edit_PathFileIdentif.Text:= OpenDialog1.FileName;
end;

procedure TForm1.BtnAddDir3Click(Sender: TObject);
begin
 EditPathWinpost.Text:= ChooseFolder('укажите каталог Winpost');
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
 Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PanelStart.Visible:= true;
  PanelOPS.Visible:= false;
  PanelRegpost.Visible:= false;
  MaskEditDataEndOPS.Text:= DateToStr(Date);

  LoadIniRegpost;
end;

function TForm1.TrueParam: boolean;
begin
 Result:= true;

 if MaskEdit_DataStart.Text = '' then Result:= false else
 if MaskEditDataEndOPS.Text = '' then Result:= false else
 if MaskEdit_IndexOPS.Text = '' then Result:= false else
 if Edit_NameOPS.Text = '' then Result:= false else
 if Edit_PathFileIdentif.Text = '' then Result:= false else
end;

function TForm1.ApplicationPath: string;
begin
  //Result := ExtractFilePath(ParamStr(0));
  Result:= 'D:\AngelWork\ProjectDelphi\Flehka\FLECHKA';
end;

function TForm1.ChooseFolder(Title: string):string;
const
     MAX_PATH = 2048;
var
     BrowseInfo: TBrowseInfo;
     lpItemID: PItemIDList;
     DisplayName: array[0..MAX_PATH] of char;
     TempPath: array[0..MAX_PATH] of char;
begin
  Result:= '';
	ZeroMemory(@BrowseInfo, sizeof(BROWSEINFO));
	BrowseInfo.hwndOwner:= Form1.Handle;
	BrowseInfo.pszDisplayName:= @DisplayName;;
	BrowseInfo.lpszTitle:= PChar(Title);
	BrowseInfo.ulFlags:= BIF_RETURNONLYFSDIRS or BIF_DONTGOBELOWDOMAIN;
	lpItemID:= SHBrowseForFolder(BrowseInfo);
	if (lpItemID <> nil) then
		if (SHGetPathFromIDList(lpItemID, TempPath)) then begin
      GlobalFreePtr(lpItemID);
			Result:= TempPath;
    end;
end;

procedure TForm1.CreateRegpostIni(path: string);
var str: TStringList;
begin
  Path:= Path + '\Regpost.ini';
  if FileExists(Path) then DeleteFile(Path);

    try
      str:= TStringList.Create;
      str.Add(';----------------------------------');
      str.Add('; nil - установить по умалчанию');
      str.Add(';----------------------------------');
      str.Add('');
      str.Add('[Regpost]');
      str.Add('');
      str.Add('; Назвние компа');
      str.Add('NameComputer = Regpost');
      str.Add('');
      str.Add('; Путь к файлу идентификации');
      str.Add('FailIfentif = nil');
      str.Add('');
      str.Add('; Каталог РПО т.е. куда кидать РПО с Флехи');
      str.Add('PathRegpost = nil');
      str.SaveToFile(Path);
    finally
       FreeAndNil(str);
    end;

end;

procedure TForm1.LoadIniRegpost;
var Ini: TIniFile;
    
    Path: string;
    Key: string;
begin
  Path:= ApplicationPath + '\' + 'Regpost';
  ForceDirectories(Path);
  try
    if not FileExists(Path + '\Regpost.ini') then CreateRegpostIni(Path);

    Ini:= TIniFile.Create(Path + '\Regpost.ini');
    if Ini.SectionExists('Regpost') then begin
      Key:= Ini.ReadString('Regpost','NameComputer', 'no');
      if Key = 'no' then begin
        Key:= '';
        CreateRegpostIni(Path);
      end else
      if Key = 'nil' then Key:= 'Regpost';

      Edit7.Text:= Key;     // Имя компутера

      Key:= Ini.ReadString('Regpost','PathRegpost', 'no');
      if Key = 'no' then begin
        Key:= '';
        CreateRegpostIni(Path);
      end else
      if Key = 'nil' then Key:= 'C\REGPOST\VXOD';

      Edit8.Text:= Key;     // Каталог Regpost

      Key:= Ini.ReadString('Regpost','FailIfentif', 'no');
      if Key = 'no' then begin
        Key:= '';
        CreateRegpostIni(Path);
      end else
      if Key = 'nil' then Key:= 'C\REGPOST\DOC\OPR-US.DOC';

      Edit9.Text:= Key;     // Путь к файлу идентификации
    end;

  finally
    FreeAndNil(Ini);
  end;
end;

end.
