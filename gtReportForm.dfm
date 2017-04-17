object DailyReportForm: TDailyReportForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1044#1085#1077#1074#1085#1086#1081' '#1086#1090#1095#1077#1090
  ClientHeight = 217
  ClientWidth = 428
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object ClipButton: TButton
    Left = 248
    Top = 187
    Width = 91
    Height = 25
    Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 0
    OnClick = ClipButtonClick
  end
  object Button2: TButton
    Left = 345
    Top = 187
    Width = 75
    Height = 25
    Caption = #1054#1050
    ModalResult = 1
    TabOrder = 1
  end
  object ReportGrid: TStringGrid
    Left = 8
    Top = 8
    Width = 412
    Height = 173
    ColCount = 3
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    TabOrder = 2
  end
end
