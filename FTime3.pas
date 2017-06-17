unit FTime3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TTime3 = class(TForm)
    Timer1: TTimer;
    Image1: TImage;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function FileVersion(AFileName: string): string;
  public
    { Public declarations }
    Timmmme: integer;
    CloseOk: boolean;
  end;

var
  Time3:  TTime3;

implementation

{$R *.dfm}

procedure TTime3.BitBtn1Click(Sender: TObject);
begin
  CloseOk:= true;
end;

procedure TTime3.FormCreate(Sender: TObject);
begin
  Timmmme:= 3;
  CloseOk:= false;
  Label2.Caption:= 'version: ' + FileVersion(Paramstr(0));

  Label1.Caption:= IntToStr(Timmmme)
end;

procedure TTime3.Timer1Timer(Sender: TObject);
begin
  if Timmmme <> 1 then begin
    Dec(Timmmme);
    Label1.Caption:= IntToStr(Timmmme);
  end else Timer1.Enabled:= false;
end;

function TTime3.FileVersion(AFileName: string): string;
var
  szName: array[0..255] of Char;
  P: Pointer;
  Value: Pointer;
  Len: UINT;
  GetTranslationString: string;
  FFileName: PChar;
  FValid: boolean;
  FSize: DWORD;
  FHandle: DWORD;
  FBuffer: PChar;
begin
  try
    FFileName := StrPCopy(StrAlloc(Length(AFileName) + 1), AFileName);
    FValid := False;
    FSize := GetFileVersionInfoSize(FFileName, FHandle);
    if FSize > 0 then
    try
      GetMem(FBuffer, FSize);
      FValid := GetFileVersionInfo(FFileName, FHandle, FSize, FBuffer);
    except
      FValid := False;
      raise;
    end;
    Result := '';
    if FValid then
      VerQueryValue(FBuffer, '\VarFileInfo\Translation', p, Len)
    else
      p := nil;
    if P <> nil then
      GetTranslationString := IntToHex(MakeLong(HiWord(Longint(P^)),
        LoWord(Longint(P^))), 8);
    if FValid then
    begin
      StrPCopy(szName, '\StringFileInfo\' + GetTranslationString +
        '\FileVersion');
      if VerQueryValue(FBuffer, szName, Value, Len) then
        Result := StrPas(PChar(Value));
    end;
  finally
    try
      if FBuffer <> nil then
        FreeMem(FBuffer, FSize);
    except
    end;
    try
      StrDispose(FFileName);
    except
    end;
  end;
end;


end.
