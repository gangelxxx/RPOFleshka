unit UnitDir;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Buttons, ExtCtrls, FileCtrl;

type
  TFormDir = class(TForm)
    Bevel1: TBevel;
    DirectoryListBox1: TDirectoryListBox;
    DriveComboBox1: TDriveComboBox;
    BtnOk: TButton;
    BtnNo: TButton;
    procedure BtnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Path: string;
  end;

var
  FormDir: TFormDir;

implementation

{$R *.dfm}

procedure TFormDir.BtnOkClick(Sender: TObject);
begin
  Path:= DirectoryListBox1.Directory;
end;

procedure TFormDir.FormCreate(Sender: TObject);
begin
  Path:= '';
end;

end.
