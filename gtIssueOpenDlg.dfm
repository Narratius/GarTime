object IssueOpenDialog: TIssueOpenDialog
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = #1053#1072#1095#1072#1090#1100' '#1079#1072#1076#1072#1095#1091
  ClientHeight = 179
  ClientWidth = 384
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 281
    Height = 161
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 70
    Height = 13
    Caption = #1053#1086#1084#1077#1088' '#1079#1072#1076#1072#1095#1080
  end
  object Label2: TLabel
    Left = 16
    Top = 56
    Width = 87
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1079#1072#1076#1072#1095#1080
  end
  object OKBtn: TButton
    Left = 300
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 300
    Top = 38
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object IssuesCombo: TComboBox
    Left = 16
    Top = 32
    Width = 265
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    OnChange = IssuesComboChange
  end
  object TitleEdit: TEdit
    Left = 16
    Top = 72
    Width = 265
    Height = 21
    TabOrder = 3
  end
end
