object RelatoriosLidera: TRelatoriosLidera
  Left = 0
  Top = 0
  Caption = 'RelatoriosLidera'
  ClientHeight = 413
  ClientWidth = 539
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 264
    Top = 264
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object frxPDF: TfrxPDFExport
    ShowDialog = False
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    PrintOptimized = False
    Outline = False
    Background = False
    HTMLTags = True
    Quality = 95
    Author = 'FastReport'
    Subject = 'FastReport PDF export'
    ProtectionFlags = [ePrint, eModify, eCopy, eAnnot]
    HideToolbar = False
    HideMenubar = False
    HideWindowUI = False
    FitWindow = False
    CenterWindow = False
    PrintScaling = False
    Left = 288
    Top = 104
  end
  object frxReport: TfrxReport
    Version = '5.2.3'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 40981.391476620400000000
    ReportOptions.LastChange = 42338.434367685200000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'procedure frxReportOnStartReport(Sender: TfrxComponent);'
      'begin'
      '  dsfrRelatorio.filter := <sFilterSql>;'
      '  dsfrRelatorio.filtered := true;                            '
      '    '
      'end;'
      ''
      'begin'
      ''
      'end.')
    OnStartReport = 'frxReportOnStartReport'
    Left = 280
    Top = 176
    Datasets = <
      item
        DataSet = frxReport.dsfrRelatorio
        DataSetName = 'dsfrRelatorio'
      end>
    Variables = <
      item
        Name = ' New Category1'
        Value = Null
      end
      item
        Name = 'nCodEmp'
        Value = Null
      end
      item
        Name = 'nCodFil'
        Value = Null
      end
      item
        Name = 'sFilterSql'
        Value = ''
      end>
    Style = <
      item
        Name = 'Title'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Fill.BackColor = clGray
      end
      item
        Name = 'Header'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
      end
      item
        Name = 'Group header'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Fill.BackColor = 16053492
      end
      item
        Name = 'Data'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
      end
      item
        Name = 'Group footer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
      end
      item
        Name = 'Header line'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        Frame.Width = 2.000000000000000000
      end>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
      object Oracle: TfrxFDDatabase
        DriverName = 'Ora'
        DatabaseName = 'Oracle'
        Params.Strings = (
          'Database=Oracle'
          'User_Name=lidera'
          'Password=lidera2017'
          'DriverID=Ora')
        LoginPrompt = False
        Connected = True
        pLeft = 184
        pTop = 92
      end
      object dsfrRelatorio: TfrxFDQuery
        UserName = 'dsfrRelatorio'
        CloseDataSource = True
        FieldAliases.Strings = (
          'CDREGISTRO=CDREGISTRO'
          'CODFOR=CODFOR'
          'CODEMP=CODEMP'
          'CODFIL=CODFIL'
          'NUMOCP=NUMOCP'
          'NUMNFC=NUMNFC'
          'CODSNF=CODSNF'
          'CDASSUNTO=CDASSUNTO'
          'DEDESCRICAO=DEDESCRICAO'
          'DEACAOCORRETIVA=DEACAOCORRETIVA'
          'DTPRAZOCORRECAO=DTPRAZOCORRECAO'
          'DECORRECAOEFETIVA=DECORRECAOEFETIVA'
          'DTBAIXA=DTBAIXA'
          'DATFOR=DATFOR'
          'HORFOR=HORFOR'
          'DATGER=DATGER'
          'HORGER=HORGER'
          'USUGER=USUGER'
          'DATALT=DATALT'
          'HORALT=HORALT'
          'USUALT=USUALT'
          'DEASSUNTO=DEASSUNTO'
          'NOMFOR=NOMFOR'
          'DESCUSUGER=DESCUSUGER'
          'DESCUSUALT=DESCUSUALT')
        BCDToCurrency = False
        IgnoreDupParams = False
        Params = <
          item
            Name = 'codEmp'
            DataType = ftInteger
            Expression = '<nCodEmp>'
          end
          item
            Name = 'codFil'
            DataType = ftInteger
            Expression = '<nCodFil>'
          end>
        SQL.Strings = (
          '/*LideraSupri.UnRegistroOcorrencia.oraDados*/'
          'SELECT ro.*,         '
          '       CAST('
          '            CASE'
          '              WHEN ro.cdAssunto = 1 THEN'
          '                '#39'Itens faltantes'#39
          '              WHEN ro.cdAssunto = 2 THEN'
          '                '#39'Embalagens danificadas'#39
          '              WHEN ro.cdAssunto = 3 THEN'
          '                '#39'Troca de produtos sem autoriza'#231#227'o'#39
          '              WHEN ro.cdAssunto = 4 THEN'
          
            '                '#39'Outros erros na entrega dos materias'#39'          ' +
            '      '
          '            END AS VARCHAR2(50)'
          '           )            AS deAssunto, '
          '       f.nomFor,         '
          '       usuGer.nmUsuario AS descUsuGer,'
          '       usuAlt.nmUsuario AS descUsuAlt'
          '  FROM lidera.for_registro_ocorrencia ro'
          
            ' INNER JOIN sapiens.E095For       f      ON (f.codFor = ro.codFo' +
            'r) '
          
            '  LEFT OUTER JOIN sapiens.E420Ocp ocp    ON (ocp.codEmp = ro.cod' +
            'Emp AND ocp.codFil = ro.codFil AND ocp.numOcp = ro.numOcp)'
          
            '  LEFT OUTER JOIN sapiens.E440Nfc nfc    ON (nfc.codEmp = ro.cod' +
            'Emp AND nfc.codFil = ro.codFil AND nfc.codFor = ro.codFor AND nf' +
            'c.numNfc = ro.numNfc AND nfc.codSnf = ro.codSnf)  '
          
            '  LEFT OUTER JOIN lidera.usuario  usuGer ON (usuGer.cdUsuarioSap' +
            ' = ro.usuGer)'
          
            '  LEFT OUTER JOIN lidera.usuario  usuAlt ON (usuAlt.cdUsuarioSap' +
            ' = ro.usuAlt)  '
          ' WHERE ro.codEmp = :codEmp'
          '   AND ro.codFil = :codFil'
          '  ')
        Database = frxReport.Oracle
        pLeft = 164
        pTop = 256
        Parameters = <
          item
            Name = 'codEmp'
            DataType = ftInteger
            Expression = '<nCodEmp>'
          end
          item
            Name = 'codFil'
            DataType = ftInteger
            Expression = '<nCodFil>'
          end>
      end
    end
    object Page1: TfrxReportPage
      Orientation = poLandscape
      PaperWidth = 297.000000000000000000
      PaperHeight = 210.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object ReportTitle1: TfrxReportTitle
        FillType = ftBrush
        Height = 55.073151430000000000
        Top = 16.000000000000000000
        Width = 1046.929810000000000000
        AllowSplit = True
        object lbTitulo: TfrxMemoView
          Align = baCenter
          Left = 382.812395715000000000
          Width = 281.305018570000000000
          Height = 24.836911430000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -21
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8W = (
            'Registro de Ocorr'#234'ncias')
          ParentFont = False
        end
      end
      object PageHeader1: TfrxPageHeader
        FillType = ftBrush
        Height = 22.677180000000000000
        Top = 92.000000000000000000
        Width = 1046.929810000000000000
        object Memo1: TfrxMemoView
          Left = 377.393940000000000000
          Top = 1.511811020000000000
          Width = 71.811070000000000000
          Height = 16.629923700000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8W = (
            'O. de Compra')
          ParentFont = False
        end
        object Memo2: TfrxMemoView
          Left = 666.818841500000000000
          Top = 1.511811020000000000
          Width = 79.370130000000000000
          Height = 16.629923700000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Prazo Corre'#231#227'o')
          ParentFont = False
        end
        object Memo4: TfrxMemoView
          Top = 1.511811020000000000
          Width = 45.354360000000000000
          Height = 16.629923700000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8W = (
            'Registro')
          ParentFont = False
        end
        object Memo5: TfrxMemoView
          Left = 216.921294020000000000
          Top = 1.511811020000000000
          Width = 68.031540000000000000
          Height = 16.629923700000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Fornecedor')
          ParentFont = False
        end
        object Memo7: TfrxMemoView
          Left = 452.425480000000000000
          Top = 1.511811020000000000
          Width = 60.472480000000000000
          Height = 16.629923700000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8W = (
            'Nota Fiscal')
          ParentFont = False
        end
        object Memo8: TfrxMemoView
          Left = 749.567410000000000000
          Top = 1.511811020000000000
          Width = 98.267780000000000000
          Height = 16.629923700000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Data Resp. Fornec.')
          ParentFont = False
        end
        object Memo9: TfrxMemoView
          Left = 514.677490000000000000
          Top = 1.511811020000000000
          Width = 149.291394720000000000
          Height = 16.629923700000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Descri'#231#227'o')
          ParentFont = False
        end
        object Memo10: TfrxMemoView
          Left = 851.717070000000000000
          Top = 1.511811020000000000
          Width = 192.756030000000000000
          Height = 16.629923700000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Corre'#231#227'o Efetiva')
          ParentFont = False
        end
        object Memo11: TfrxMemoView
          Left = 47.913385830000000000
          Top = 1.511811020000000000
          Width = 147.401604090000000000
          Height = 16.629923700000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Assunto')
          ParentFont = False
        end
        object Line1: TfrxLineView
          Top = 18.677165350000000000
          Width = 1046.929810000000000000
          Color = clBlack
          Frame.Typ = [ftTop]
        end
        object Line2: TfrxLineView
          Width = 1118.740880000000000000
          Color = clBlack
          Frame.Typ = [ftTop]
        end
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Height = 15.118120000000000000
        Top = 136.000000000000000000
        Width = 1046.929810000000000000
        DataSet = frxReport.dsfrRelatorio
        DataSetName = 'dsfrRelatorio'
        RowCount = 0
        Stretched = True
        object dsfrRelatorioDESITUACAO: TfrxMemoView
          Left = 377.393940000000000000
          Width = 69.921259840000000000
          Height = 11.338590000000000000
          DataField = 'NUMOCP'
          DataSet = frxReport.dsfrRelatorio
          DataSetName = 'dsfrRelatorio'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8W = (
            '[dsfrRelatorio."NUMOCP"]')
          ParentFont = False
        end
        object dsfrRelatorioCODIGO: TfrxMemoView
          Width = 45.354360000000000000
          Height = 11.338590000000000000
          DataField = 'CDREGISTRO'
          DataSet = frxReport.dsfrRelatorio
          DataSetName = 'dsfrRelatorio'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8W = (
            '[dsfrRelatorio."CDREGISTRO"]')
          ParentFont = False
        end
        object dsfrRelatorioDEAREA: TfrxMemoView
          Left = 198.094620000000000000
          Width = 49.133890000000000000
          Height = 11.338590000000000000
          DataField = 'CODFOR'
          DataSet = frxReport.dsfrRelatorio
          DataSetName = 'dsfrRelatorio'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8W = (
            '[dsfrRelatorio."CODFOR"]')
          ParentFont = False
        end
        object dsfrRelatorioDETIPOPROCESSO: TfrxMemoView
          Left = 249.346630000000000000
          Width = 124.724490000000000000
          Height = 11.338590000000000000
          StretchMode = smMaxHeight
          DataField = 'NOMFOR'
          DataSet = frxReport.dsfrRelatorio
          DataSetName = 'dsfrRelatorio'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[dsfrRelatorio."NOMFOR"]')
          ParentFont = False
        end
        object dsfrRelatorioCDCONTRATO: TfrxMemoView
          Left = 451.086890000000000000
          Width = 60.472480000000000000
          Height = 11.338590000000000000
          DataField = 'NUMNFC'
          DataSet = frxReport.dsfrRelatorio
          DataSetName = 'dsfrRelatorio'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8W = (
            '[dsfrRelatorio."NUMNFC"]')
          ParentFont = False
        end
        object dsfrRelatorioCDBR: TfrxMemoView
          Left = 749.567410000000000000
          Width = 98.267716540000000000
          Height = 11.338590000000000000
          DataField = 'DATFOR'
          DataSet = frxReport.dsfrRelatorio
          DataSetName = 'dsfrRelatorio'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8W = (
            '[dsfrRelatorio."DATFOR"]')
          ParentFont = False
        end
        object dsfrRelatorioNUPROCESSO: TfrxMemoView
          Left = 514.677490000000000000
          Width = 149.291394720000000000
          Height = 11.338590000000000000
          DataField = 'DEDESCRICAO'
          DataSet = frxReport.dsfrRelatorio
          DataSetName = 'dsfrRelatorio'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[dsfrRelatorio."DEDESCRICAO"]')
          ParentFont = False
        end
        object dsfrRelatorioSGUF: TfrxMemoView
          Left = 851.717070000000000000
          Width = 188.976500000000000000
          Height = 11.338590000000000000
          DataField = 'DECORRECAOEFETIVA'
          DataSet = frxReport.dsfrRelatorio
          DataSetName = 'dsfrRelatorio'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8W = (
            '[dsfrRelatorio."DECORRECAOEFETIVA"]')
          ParentFont = False
        end
        object dsfrRelatorioDEASSUNTO: TfrxMemoView
          Left = 47.913420000000000000
          Width = 147.401670000000000000
          Height = 11.338590000000000000
          StretchMode = smMaxHeight
          DataField = 'DEASSUNTO'
          DataSet = frxReport.dsfrRelatorio
          DataSetName = 'dsfrRelatorio'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[dsfrRelatorio."DEASSUNTO"]')
          ParentFont = False
        end
        object dsfrRelatorioNOMECLIENTE: TfrxMemoView
          Left = 666.708661420000000000
          Width = 79.370130000000000000
          Height = 11.338580240000000000
          StretchMode = smMaxHeight
          DataField = 'DTPRAZOCORRECAO'
          DataSet = frxReport.dsfrRelatorio
          DataSetName = 'dsfrRelatorio'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8W = (
            '[dsfrRelatorio."DTPRAZOCORRECAO"]')
          ParentFont = False
        end
        object Line3: TfrxLineView
          Top = 13.338590000000000000
          Width = 1046.929810000000000000
          Color = clBlack
          Frame.Typ = [ftTop]
        end
      end
      object Footer2: TfrxFooter
        FillType = ftBrush
        Height = 22.677180000000000000
        Top = 172.000000000000000000
        Width = 1046.929810000000000000
        object Now: TfrxMemoView
          Left = 721.890230000000000000
          Width = 325.039580000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8W = (
            'Data e hora de impress'#227'o: [Now]')
          ParentFont = False
        end
      end
    end
  end
end
