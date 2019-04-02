object Main: TMain
  Left = 301
  Top = 125
  Width = 1222
  Height = 825
  Caption = 'Kuber'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox3: TGroupBox
    Left = 600
    Top = 0
    Width = 606
    Height = 766
    Align = alRight
    Caption = 'YAML'
    TabOrder = 0
    object MemoYaml: TMemo
      Left = 2
      Top = 15
      Width = 602
      Height = 749
      Align = alClient
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        '')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 766
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object MemoMain: TMemo
      Left = 0
      Top = 640
      Width = 600
      Height = 126
      Align = alBottom
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 1
      WordWrap = False
    end
    object GroupBox1: TGroupBox
      Left = 0
      Top = 145
      Width = 600
      Height = 137
      Align = alTop
      Caption = 'Nodes'
      TabOrder = 2
      object StringGridNodes: TStringGrid
        Left = 2
        Top = 15
        Width = 596
        Height = 120
        Align = alClient
        ColCount = 1
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
        TabOrder = 0
        OnDblClick = StringGridNodesDblClick
        OnKeyDown = StringGridKeyDown
      end
    end
    object GroupBox2: TGroupBox
      Left = 0
      Top = 282
      Width = 600
      Height = 192
      Align = alTop
      Caption = 'Pods'
      TabOrder = 3
      object StringGridPods: TStringGrid
        Left = 2
        Top = 15
        Width = 596
        Height = 175
        Align = alClient
        ColCount = 1
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
        TabOrder = 0
        OnDblClick = StringGridPodsDblClick
        OnKeyDown = StringGridKeyDown
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 600
      Height = 145
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object GroupBox4: TGroupBox
        Left = 0
        Top = 0
        Width = 241
        Height = 145
        Align = alLeft
        Caption = 'Namespaces'
        TabOrder = 0
        object StringGridNamespaces: TStringGrid
          Left = 2
          Top = 15
          Width = 237
          Height = 128
          Align = alClient
          ColCount = 1
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
          TabOrder = 0
          OnDblClick = StringGridNamespacesDblClick
          OnKeyDown = StringGridKeyDown
        end
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 88
    Top = 8
    object Main1: TMenuItem
      Caption = 'Main'
      object N1: TMenuItem
        Caption = 'Storages'
      end
    end
  end
end
