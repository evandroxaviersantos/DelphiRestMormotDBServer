object ServidorRestFr: TServidorRestFr
  Left = 0
  Top = 0
  Caption = 'ServidorRestFr'
  ClientHeight = 336
  ClientWidth = 725
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object mmLogSrv: TMemo
    Left = 0
    Top = 57
    Width = 725
    Height = 279
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 725
    Height = 57
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      AlignWithMargins = True
      Left = 292
      Top = 16
      Width = 36
      Height = 37
      Margins.Top = 15
      Align = alLeft
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoSize = False
      BiDiMode = bdLeftToRight
      Caption = 'Banco:'
      ParentBiDiMode = False
      ExplicitLeft = 284
      ExplicitTop = 14
      ExplicitHeight = 29
    end
    object Label2: TLabel
      AlignWithMargins = True
      Left = 154
      Top = 16
      Width = 36
      Height = 37
      Margins.Top = 15
      Align = alLeft
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoSize = False
      BiDiMode = bdLeftToRight
      Caption = 'Porta:'
      ParentBiDiMode = False
      ExplicitHeight = 29
    end
    object btnPararSvr: TButton
      Left = 76
      Top = 1
      Width = 75
      Height = 55
      Align = alLeft
      Caption = 'Parar'
      TabOrder = 1
      OnClick = btnPararSvrClick
    end
    object btnIniciarSrv: TButton
      Left = 1
      Top = 1
      Width = 75
      Height = 55
      Align = alLeft
      Caption = 'Iniciar'
      TabOrder = 2
      OnClick = btnIniciarSrvClick
    end
    object edtPorta: TEdit
      Left = 193
      Top = 1
      Width = 96
      Height = 55
      Align = alLeft
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 40
      Font.Name = 'Tahoma'
      Font.Style = []
      NumbersOnly = True
      ParentFont = False
      TabOrder = 3
      Text = '888'
      OnChange = edtPortaChange
      ExplicitHeight = 48
    end
    object rdgBanco: TRadioGroup
      Left = 331
      Top = 1
      Width = 174
      Height = 55
      Align = alLeft
      BiDiMode = bdLeftToRight
      ItemIndex = 0
      Items.Strings = (
        'C:\tempprojects\detran.db3')
      ParentBiDiMode = False
      TabOrder = 0
    end
  end
  object tmrLog: TTimer
    Interval = 3600000
    OnTimer = tmrLogTimer
    Left = 424
    Top = 152
  end
end
