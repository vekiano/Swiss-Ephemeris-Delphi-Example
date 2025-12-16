object FrmMapaExemplo: TFrmMapaExemplo
  Left = 0
  Top = 0
  Caption = 'Swiss Ephemeris Delphi - Example'
  ClientHeight = 500
  ClientWidth = 700
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 700
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object BtnCalcular: TButton
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 180
      Height = 29
      Margins.Left = 10
      Margins.Top = 10
      Margins.Bottom = 10
      Align = alLeft
      Caption = 'Calculate Chart (Obama)'
      TabOrder = 0
      OnClick = BtnCalcularClick
    end
  end
  object MemoLog: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 52
    Width = 694
    Height = 445
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    Lines.Strings = (
      '1. Ensure swedll32.dll is in the executable folder.'
      
        '2. Ensure there is an "ephe" folder with .se1 files next to the ' +
        'executable.'
      '3. Click Calculate.')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
