object Main: TMain
  Left = 301
  Top = 125
  Width = 870
  Height = 640
  Caption = 'Main'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 20
  object Memo1: TMemo
    Left = 32
    Top = 280
    Width = 761
    Height = 209
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object Button1: TButton
    Left = 64
    Top = 72
    Width = 121
    Height = 41
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 200
    Top = 72
    Width = 121
    Height = 41
    Caption = 'get pods -o wide'
    TabOrder = 2
    OnClick = Button2Click
  end
end
