object FormDir: TFormDir
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1076#1080#1088#1077#1082#1090#1086#1088#1080#1102'...'
  ClientHeight = 292
  ClientWidth = 260
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 248
    Width = 241
    Height = 9
    Shape = bsBottomLine
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 9
    Top = 33
    Width = 241
    Height = 209
    ItemHeight = 16
    TabOrder = 0
  end
  object DriveComboBox1: TDriveComboBox
    Left = 8
    Top = 8
    Width = 244
    Height = 19
    DirList = DirectoryListBox1
    TabOrder = 1
  end
  object BtnOk: TButton
    Left = 94
    Top = 263
    Width = 75
    Height = 25
    Caption = #1044#1072
    ModalResult = 1
    TabOrder = 2
    OnClick = BtnOkClick
  end
  object BtnNo: TButton
    Left = 175
    Top = 263
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
end
