object MainForm: TMainForm
  Left = 1934
  Top = 97
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1056#1072#1073#1086#1095#1077#1077' '#1074#1088#1077#1084#1103
  ClientHeight = 103
  ClientWidth = 263
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object timeUpdate: TTimer
    Enabled = False
    OnTimer = timeUpdateTimer
    Left = 144
    Top = 56
  end
  object TrayMenu: TPopupMenu
    Left = 16
    Top = 8
    object itemStartStop: TMenuItem
      Action = actStart
      Default = True
    end
    object N1: TMenuItem
      Action = actConfig
    end
    object itemExit: TMenuItem
      Action = actExit
    end
  end
  object ActionList1: TActionList
    Left = 72
    Top = 8
    object actStart: TAction
      Caption = #1057#1090#1072#1088#1090
      OnExecute = btStartClick
    end
    object actStop: TAction
      Caption = #1057#1090#1086#1087
      OnExecute = btStopClick
    end
    object actExit: TAction
      Caption = #1042#1099#1093#1086#1076
      OnExecute = actExitExecute
    end
    object actShowStatistic: TAction
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1091
      OnExecute = actShowStatisticExecute
    end
    object actConfig: TAction
      Caption = #1050#1086#1085#1092#1080#1075#1091#1088#1072#1094#1080#1103'...'
      OnExecute = actConfigExecute
    end
  end
  object IconImages: TImageList
    Left = 216
    Top = 32
    Bitmap = {
      494C010104000900300010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000004287D00061D5F00061C6100061D5F00051B5B0001216B000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000047D0400065F0A0006610B00065F0A00055B0900016B01000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000002D3036002224290022242900222429002022260025282D000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000374037002C322D002D342D002C322D002A302A002E362E000000
      000000000000000000000000000000000000000000000000000000000000072F
      8C00072F8C00072F8C001432A6000F2DA5000E2DA4000D2CA2000B279100061D
      6600001F6800000000000000000000000000000000000000000000000000078C
      0700078C0700078C070014A622000FA51E000EA41C000DA21B000B9117000666
      0C00006800000000000000000000000000000000000000000000000000003437
      3E0034373E0034373E003D3F47003A3C45003A3C4400393A430032343C002425
      2B0024262C000000000000000000000000000000000000000000000000003F49
      3F003F493F003F493F00525D5300505B51004F5A50004E584F00454F46002F36
      30002D342D00000000000000000000000000000000000000000008319600072F
      8C00283CBD00B2AFEE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000F31
      AC0008227100002169000000000000000000000000000000000008960A00078C
      070028BD410022B637001DB0300017AC280011A721000FA61C000EA71D000FAC
      1C0008710E000169000000000000000000000000000000000000373A42003437
      3E004A4B54009C9CA000CFCFCF00CFCFCF00CFCFCF00CFCFCF00CFCFCF003D40
      4900292A300025282D0000000000000000000000000000000000444F44003F49
      3F0066716800606B61005B665C0057615700525D5300505B5100505C5200535E
      5300353D35002D352D000000000000000000000000000A36A000083196003340
      C400B5B5B500DBDBDB00EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00FFFF
      FF000E2EAA0008217100001F690000000000000000000AA00B0008960A0033C4
      520030C14D002EC24B0029BE450074D38300C2EBC80029B53A000FAA20000DA8
      1D000EAA1D0008710F000069010000000000000000003C3F4600373A42004F4F
      590093939300B1B1B100C2C2C200C2C2C200C2C2C200C2C2C200C2C2C200CFCF
      CF003B3E4600282A300024262C00000000000000000049534900444F44006E79
      71006C766E006B766D00687269008A918B00B0B3B100616C6200535E5300515C
      5200525D5300353D35002D352D0000000000000000000A36A0003E46CD00B5B5
      B500EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00E7E7E700EFEF
      EF00FFFFFF000E2EAC00061C640000000000000000000AA00B003ECD610037C7
      58003AC85C0038C9590082DB9500F0FAF200FFFFFF0065CC740017B02B0011AB
      23000EA51C000EAC1D0006640C0000000000000000003C3F4600555560009393
      9300C2C2C200C2C2C200C2C2C200C2C2C200C2C2C200C2C2C200BBBBBB00C2C2
      C200CFCFCF003C3E47002324290000000000000000004953490077827A00717C
      7400747E7600737E7500939A9500C6C7C700CFCFCF008289820059645B005460
      55004F5B5000535E53002E352F00000000000D3EAD00313CBA00B5B5B500EFEF
      EF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00D1D1D1003B3B3B00E7E7
      E700EFEFEF00FFFFFF000C2A930001216C000EAD0D0031BA4F0042D068003BCC
      5D003ECD62008DE1A100F4FCF600FFFFFF00FFFFFF00A9E3B3001DB2320015AE
      29000FA71F000DA81C000C931700016C010042464F004B4B540093939300C2C2
      C200C2C2C200C2C2C200C2C2C200C2C2C200C2C2C200A9A9A90030303000BBBB
      BB00C2C2C200CFCFCF0034363E0026292D004F5B4F0069736C007B867E007580
      780078827A009BA09C00C9CACA00CFCFCF00CFCFCF00A4A8A4005C675E005763
      5900515C5200505C5200465047002F362F000E2D9E004549CD00B5B5B500EFEF
      EF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00D1D1D1003B3B3B00D1D1D100EFEF
      EF00EFEFEF00FFFFFF000D2CA200051B5B000E9E1A0045CD6A0047D26D0040CC
      63009CE5AE00F9FDFA00FFFFFF00D8F4DE00E0F6E500DFF5E20038BD4C0018B0
      2B0013A923000FA71E000DA21B00055B0900383A42005757610093939300C2C2
      C200C2C2C200C2C2C200C2C2C200C2C2C200A9A9A90030303000A9A9A900C2C2
      C200C2C2C200CFCFCF00393A4300202226004C574D007A857E007E8881007882
      7A00A1A7A300CBCBCB00CFCFCF00BCBEBD00C0C2C000BEC0BE006B756D005964
      5B00535F5400515C52004E584F002A302A001331A2005D5CDA00B5B5B500EFEF
      EF00EFEFEF00EFEFEF00EFEFEF003636360025252500D1D1D100EFEFEF00EFEF
      EF00EFEFEF00FFFFFF00102FA600061C5F0013A220005CDA830050D7780043D0
      6900F7FDF900FFFFFF00C8F0D20052D06E0070D58500F8FDF90078D487001EB4
      330019AE2B0014AA240010A61E00065F0B003B3E460066666F0093939300C2C2
      C200C2C2C200C2C2C200C2C2C2002C2C2C001E1E1E00A9A9A900C2C2C200C2C2
      C200C2C2C200CFCFCF003B3E4600222329004F5A510089938C00848E86007B86
      7E00CBCBCB00CFCFCF00B5B8B6007E8881008B928C00CBCBCB008C938D005D68
      5F0058635A0054605500505C52002C322D001634A5008482E500B5B5B500EFEF
      EF00EFEFEF00EFEFEF00EFEFEF006262620036363600C2C2C200EFEFEF00EFEF
      EF00EFEFEF00FFFFFF001733AB00071D610016A5230082E5A20065DF8E0049D6
      7400B6EDC500B8EEC6004BD26C0039CB5B003BC85900C2EDCA00C5EDCC0026B9
      3D001FB533001BAF2F0017AB270007610C003E4048007F7F860093939300C2C2
      C200C2C2C200C2C2C200C2C2C2004F4F4F002C2C2C009D9D9D00C2C2C200C2C2
      C200C2C2C200CFCFCF003F414A0023242900525C53009BA29D008F989300828B
      8400AEB2AF00AFB3B0007E888100757F7700737E7500B1B5B100B2B5B200636E
      64005E6960005A645C00566057002D342D001130A1008E8EE600B5B5B500DBDB
      DB00EFEFEF00EFEFEF00EFEFEF00EFEFEF00D1D1D1003B3B3B00D1D1D100EFEF
      EF00EFEFEF00FFFFFF001B35AC00061C5F0011A11D008EE6A8008EE9AD0056E3
      83005CE4870040D4650043D46A003ECF630039CB5B0065D47C00D9F4DE0069D0
      7B0023B83A0021B537001BAC2D00065F0B003A3D450086868C0093939300B1B1
      B100C2C2C200C2C2C200C2C2C200C2C2C200A9A9A90030303000A9A9A900C2C2
      C200C2C2C200CFCFCF0041424B00222329004F594F009FA5A000A1A8A3008C97
      8F008F9892007C867E007E88800079837B00757F7700868F8800BCBEBD00858D
      8600616D6300606A610058635A002C322D001044BC006E77D500B5B5B500DBDB
      DB00EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00C2C2C2003B3B3B00E0E0
      E000EFEFEF00FFFFFF001B32A300052B820010BC10006ED58400C1F6D50071ED
      9A0058E3840045D36B0046D76F0043D46A003ED063003DCC5E0099E3A900A9E5
      B40029BB430028BD41001BA32D0005820500494D560073747B0093939300B1B1
      B100C2C2C200C2C2C200C2C2C200C2C2C200C2C2C2009D9D9D0030303000B5B5
      B500C2C2C200CFCFCF003E3F470030323900576457008B928B00B7BBB9009AA3
      9D008D9790007E888000808B83007E8880007A847C00768179009FA4A000A5A9
      A6006671680066716800545E56003A433A00000000001044BC00C0BCF400B5B5
      B500DBDBDB00EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00ABABAB009C9C
      9C00FFFFFF00303FC40008319100000000000000000010BC1000BCF4D100C1F8
      D4005CE087005CE0870055DE800047D7700043D46B003ECF64004ED16D0099E3
      A9002FC34C0030C44D00089108000000000000000000494D5600A5A4A8009393
      9300B1B1B100C2C2C200C2C2C200C2C2C200C2C2C200C2C2C2008B8B8B007E7E
      7E00CFCFCF004E4F580036394000000000000000000057645700B5B9B600B8BC
      B9008D9790008D97900089938C00818B83007E88800079837C007E8881009FA4
      A0006C776E006D786F00424B420000000000000000001044BC001044BC00D5D1
      F900B5B5B500DBDBDB00EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00FFFF
      FF003B43CB000831910008319100000000000000000010BC100010BC1000D1F9
      E100CCF9DC0085E8A5005CE087004DDA790047D7710043D46A0040CF640063D5
      7F003BCB5E0008910800089108000000000000000000494D5600494D5600B2B2
      B50093939300B1B1B100C2C2C200C2C2C200C2C2C200C2C2C200C2C2C200CFCF
      CF0053535D00363940003639400000000000000000005764570057645700BEC1
      BF00BCBFBD009DA4A0008D979000858F8800818B84007E8880007A847C00878F
      8A0075807800424B4200424B42000000000000000000000000001044BC001044
      BC00C5C1F500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B5005457
      D7000A369B000A369B000000000000000000000000000000000010BC100010BC
      1000C1F5D500DFFDEB00C4F6D700A5EEBE0090E9AD0089E6A70078E3970054D7
      78000A9B0A000A9B0A0000000000000000000000000000000000494D5600494D
      5600A8A8AC009393930093939300939393009393930093939300939393006262
      6C003A3E46003A3E460000000000000000000000000000000000576457005764
      5700B7BAB900C4C6C500B8BCB900AAB0AD00A1A8A4009DA4A000969E9800848E
      8700465146004651460000000000000000000000000000000000000000001044
      BC001044BC006F77D400A1A0E900B2AFEE00A5A4EC008081E0004A55C5000C3A
      A5000C3AA50000000000000000000000000000000000000000000000000010BC
      100010BC10006FD48500A0E9B700AFEEC500A4ECBB0080E09C004AC564000CA5
      0C000CA50C00000000000000000000000000000000000000000000000000494D
      5600494D560073747A00929297009C9CA00094949A007D7D84005C5C64003F42
      4B003F424B000000000000000000000000000000000000000000000000005764
      5700576457008B928B00A6ABA800ADB2AF00A8AEAA00979E9900767F79004B57
      4B004B574B000000000000000000000000000000000000000000000000000000
      0000000000001044BC001044BC001044BC001044BC001044BC000E3FB1000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000010BC100010BC100010BC100010BC100010BC10000EB10E000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000494D5600494D5600494D5600494D5600494D5600444750000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005764570057645700576457005764570057645700525D52000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000F81FF81FF81FF81FE007E007E007E007
      C003C003C003C003800180018001800180018001800180010000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000080018001800180018001800180018001C003C003C003C003
      E007E007E007E007F81FF81FF81FF81F00000000000000000000000000000000
      000000000000}
  end
  object AppEvents: TApplicationEvents
    OnMessage = AppEventsMessage
    OnMinimize = AppEventsMinimize
    Left = 144
    Top = 8
  end
  object TrayIcon: TCoolTrayIcon
    IconList = IconImages
    CycleInterval = 0
    Icon.Data = {
      0000010001001010200000000000680400001600000028000000100000002000
      0000010020000000000000040000000000000000000000000000000000000000
      00000000000000000000000000000000000004287D00061D5F00061C6100061D
      5F00051B5B0001216B0000000000000000000000000000000000000000000000
      00000000000000000000072F8C00072F8C00072F8C001432A6000F2DA5000E2D
      A4000D2CA2000B279100061D6600001F68000000000000000000000000000000
      00000000000008319600072F8C00283CBD00B2AFEE00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000F31AC00082271000021690000000000000000000000
      00000A36A000083196003340C400B5B5B500DBDBDB00EFEFEF00EFEFEF00EFEF
      EF00EFEFEF00EFEFEF00FFFFFF000E2EAA0008217100001F6900000000000000
      00000A36A0003E46CD00B5B5B500EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEF
      EF00EFEFEF00E7E7E700EFEFEF00FFFFFF000E2EAC00061C6400000000000D3E
      AD00313CBA00B5B5B500EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEF
      EF00D1D1D1003B3B3B00E7E7E700EFEFEF00FFFFFF000C2A930001216C000E2D
      9E004549CD00B5B5B500EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00D1D1
      D1003B3B3B00D1D1D100EFEFEF00EFEFEF00FFFFFF000D2CA200051B5B001331
      A2005D5CDA00B5B5B500EFEFEF00EFEFEF00EFEFEF00EFEFEF00363636002525
      2500D1D1D100EFEFEF00EFEFEF00EFEFEF00FFFFFF00102FA600061C5F001634
      A5008482E500B5B5B500EFEFEF00EFEFEF00EFEFEF00EFEFEF00626262003636
      3600C2C2C200EFEFEF00EFEFEF00EFEFEF00FFFFFF001733AB00071D61001130
      A1008E8EE600B5B5B500DBDBDB00EFEFEF00EFEFEF00EFEFEF00EFEFEF00D1D1
      D1003B3B3B00D1D1D100EFEFEF00EFEFEF00FFFFFF001B35AC00061C5F001044
      BC006E77D500B5B5B500DBDBDB00EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEF
      EF00C2C2C2003B3B3B00E0E0E000EFEFEF00FFFFFF001B32A300052B82000000
      00001044BC00C0BCF400B5B5B500DBDBDB00EFEFEF00EFEFEF00EFEFEF00EFEF
      EF00EFEFEF00ABABAB009C9C9C00FFFFFF00303FC40008319100000000000000
      00001044BC001044BC00D5D1F900B5B5B500DBDBDB00EFEFEF00EFEFEF00EFEF
      EF00EFEFEF00EFEFEF00FFFFFF003B43CB000831910008319100000000000000
      0000000000001044BC001044BC00C5C1F500B5B5B500B5B5B500B5B5B500B5B5
      B500B5B5B500B5B5B5005457D7000A369B000A369B0000000000000000000000
      000000000000000000001044BC001044BC006F77D400A1A0E900B2AFEE00A5A4
      EC008081E0004A55C5000C3AA5000C3AA5000000000000000000000000000000
      0000000000000000000000000000000000001044BC001044BC001044BC001044
      BC001044BC000E3FB1000000000000000000000000000000000000000000F81F
      0000E0070000C003000080010000800100000000000000000000000000000000
      000000000000000000008001000080010000C0030000E0070000F81F0000}
    IconVisible = True
    IconIndex = 0
    PopupMenu = TrayMenu
    MinimizeToTray = True
    OnClick = actShowStatisticExecute
    OnStartup = TrayIconStartup
    Left = 16
    Top = 56
  end
end
