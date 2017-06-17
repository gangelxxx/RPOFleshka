program RPOFlehka;


{%TogetherDiagram 'ModelSupport_RPOFlehka\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_RPOFlehka\UnitMain\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_RPOFlehka\FTime3\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_RPOFlehka\RPOFlehka\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_RPOFlehka\UnitSpisRPO\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_RPOFlehka\UnitMessageOk\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_RPOFlehka\UnitCompareFiles\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_RPOFlehka\UnitMessageProgrammer\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_RPOFlehka\UnitViewDir\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_RPOFlehka\UnitMessageUpdate\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_RPOFlehka\UnitEjectUsb\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_RPOFlehka\default.txvpck'}

uses
  Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitCompareFiles in 'UnitCompareFiles.pas',
  FTime3 in 'FTime3.pas' {Time3},
  UnitSpisRPO in 'UnitSpisRPO.pas',
  UnitEjectUsb in 'UnitEjectUsb.pas',
  UnitViewDir in 'UnitViewDir.pas',
  UnitMessageUpdate in 'UnitMessageUpdate.pas' {FormGibridUpdate},
  UnitMessageProgrammer in 'UnitMessageProgrammer.pas' {FormProgrammer},
  UnitMessageOk in 'UnitMessageOk.pas' {FormProgrammOk};

{$R *.res}
var F: boolean;
begin
  Application.Initialize;
    Time3:= TTime3.Create(Application);
    Time3.Show;
    Time3.Update;

    while Time3.Timer1.Enabled and not Time3.CloseOk do
     Application.ProcessMessages;

  F:= Time3.CloseOk;
  Time3.Hide;
  Time3.Free;

  if F = False then
  begin
    Application.CreateForm(TFormMain, FormMain);
  Application.Run;
  end;
end.
