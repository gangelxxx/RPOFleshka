unit UnitMessageProgrammer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormProgrammer = class(TForm)
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
  FormProgrammer: TFormProgrammer;

implementation

{$R *.dfm}

procedure TFormProgrammer.Button1Click(Sender: TObject);
begin
  CloseOk:= true;
end;

procedure TFormProgrammer.FormCreate(Sender: TObject);
begin
 CloseOk:= false;
end;

procedure TFormProgrammer.Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  x0 := x;
  y0 := y
end;

procedure TFormProgrammer.Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if (ssLeft in Shift) then
  begin
    FormProgrammer.Left:=  FormProgrammer.Left + x - x0;
    FormProgrammer.Top:=  FormProgrammer.Top + y - y0;
  end;
end;

end.
