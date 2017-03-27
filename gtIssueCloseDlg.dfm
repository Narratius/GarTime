object IssueCloseDialog: TIssueCloseDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1047#1072#1082#1088#1099#1090#1080#1077' '#1072#1082#1090#1080#1074#1085#1086#1081' '#1079#1072#1076#1072#1095#1080
  ClientHeight = 113
  ClientWidth = 404
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
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 115
    Height = 13
    Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081' '#1082' '#1079#1072#1076#1072#1095#1077
  end
  object CommentEdit: TEdit
    Left = 8
    Top = 27
    Width = 385
    Height = 21
    TabOrder = 0
  end
  object OKButton: TButton
    Left = 224
    Top = 80
    Width = 75
    Height = 25
    Caption = #1054#1050
    ModalResult = 1
    TabOrder = 1
  end
  object CancelButton: TButton
    Left = 318
    Top = 80
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object IssueClosedCheck: TCheckBox
    Left = 8
    Top = 56
    Width = 105
    Height = 17
    Caption = #1047#1072#1082#1088#1099#1090#1100' '#1079#1072#1076#1072#1095#1091
    TabOrder = 3
  end
end
