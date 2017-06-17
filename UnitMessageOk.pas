unit UnitMessageOk;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormProgrammOk = class(TForm)
    Image1: TImage;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    x0,y0: integer;
  public
    { Public declarations }
    CloseOk: boolean;
  end;

var
  FormProgrammOk: TFormProgrammOk;

implementation

{$R *.dfm}

procedure TFormProgrammOk.Button1Click(Sender: TObject);
begin
  CloseOk:= true;
end;

procedure TFormProgrammOk.FormCreate(Sender: TObject);
begin
 CloseOk:= false;
end;

procedure TFormProgrammOk.Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  x0 := x;
  y0 := y
end;

procedure TFormProgrammOk.Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if (ssLeft in Shift) then
  begin
    FormProgrammOk.Left:=  FormProgrammOk.Left + x - x0;
    FormProgrammOk.Top:=  FormProgrammOk.Top + y - y0;
  end;
end;

end.
