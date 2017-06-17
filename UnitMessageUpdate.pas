unit UnitMessageUpdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TFormGibridUpdate = class(TForm)
    Image1: TImage;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    x0,y0: integer;
  public
    { Public declarations }
    CloseOk: boolean;
  end;

var
  FormGibridUpdate: TFormGibridUpdate;

implementation

{$R *.dfm}

procedure TFormGibridUpdate.BitBtn1Click(Sender: TObject);
begin
  CloseOk:= true;
end;

procedure TFormGibridUpdate.FormCreate(Sender: TObject);
begin
  CloseOk:= false;
end;

procedure TFormGibridUpdate.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  x0 := x;
  y0 := y
end;

procedure TFormGibridUpdate.Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if (ssLeft in Shift) then
  begin
    FormGibridUpdate.Left:=  FormGibridUpdate.Left + x - x0;
    FormGibridUpdate.Top:=  FormGibridUpdate.Top + y - y0;
  end;
end;

end.
