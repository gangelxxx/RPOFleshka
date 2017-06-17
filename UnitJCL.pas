unit UnitJCL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, JclDebug;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var 
  StackInfoList: TJclStackInfoList;
begin 
  StackInfoList := JclCreateStackList(true, 0, nil);
  try
    Memo1.Lines.BeginUpdate; 
    Memo1.Lines.Clear; 
    StackInfoList.AddToStrings(Memo1.Lines, true, true, true); 
    Memo1.Lines.EndUpdate; 
  finally 
    StackInfoList.Free;
  end; 
end;

end.
