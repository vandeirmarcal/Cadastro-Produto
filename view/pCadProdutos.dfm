object Fcadprodutos: TFcadprodutos
  Left = 0
  Top = 0
  Caption = 'Cadastro de Produtos'
  ClientHeight = 482
  ClientWidth = 926
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Loperacao: TLabel
    Left = 8
    Top = 431
    Width = 91
    Height = 22
    Caption = 'Opera'#231#227'o'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object pnBotoesAcao: TPanel
    Left = 0
    Top = 48
    Width = 926
    Height = 176
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Lcodigo: TLabel
      Left = 1
      Top = 129
      Width = 33
      Height = 14
      Caption = 'C'#243'digo'
    end
    object Lnome: TLabel
      Left = 211
      Top = 129
      Width = 27
      Height = 14
      Caption = 'Nome'
    end
    object Lunidade: TLabel
      Left = 421
      Top = 129
      Width = 39
      Height = 14
      Caption = 'Unidade'
    end
    object GBconsulta: TGroupBox
      Left = 3
      Top = 1
      Width = 875
      Height = 44
      Caption = 'Consultar'
      TabOrder = 0
      object CBconsulta: TComboBox
        Left = 8
        Top = 14
        Width = 145
        Height = 22
        ItemIndex = 0
        TabOrder = 0
        Text = 'Todos'
        OnCloseUp = CBconsultaCloseUp
        Items.Strings = (
          'Todos'
          'C'#243'digo'
          'Nome')
      end
      object Econsulta: TEdit
        Left = 159
        Top = 15
        Width = 191
        Height = 21
        TabStop = False
        AutoSize = False
        CharCase = ecUpperCase
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 50
        ParentFont = False
        TabOrder = 1
      end
      object BitBtn1: TBitBtn
        Tag = 1
        Left = 382
        Top = 14
        Width = 120
        Height = 22
        Caption = 'Consultar (F7)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Glyph.Data = {
          36060000424D3606000000000000360400002800000020000000100000000100
          08000000000000020000120B0000120B00000001000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
          A6000020400000206000002080000020A0000020C0000020E000004000000040
          20000040400000406000004080000040A0000040C0000040E000006000000060
          20000060400000606000006080000060A0000060C0000060E000008000000080
          20000080400000806000008080000080A0000080C0000080E00000A0000000A0
          200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
          200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
          200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
          20004000400040006000400080004000A0004000C0004000E000402000004020
          20004020400040206000402080004020A0004020C0004020E000404000004040
          20004040400040406000404080004040A0004040C0004040E000406000004060
          20004060400040606000406080004060A0004060C0004060E000408000004080
          20004080400040806000408080004080A0004080C0004080E00040A0000040A0
          200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
          200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
          200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
          20008000400080006000800080008000A0008000C0008000E000802000008020
          20008020400080206000802080008020A0008020C0008020E000804000008040
          20008040400080406000804080008040A0008040C0008040E000806000008060
          20008060400080606000806080008060A0008060C0008060E000808000008080
          20008080400080806000808080008080A0008080C0008080E00080A0000080A0
          200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
          200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
          200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
          2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
          2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
          2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
          2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
          2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
          2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
          2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FDFDFDFDFDFD
          FDFDFDFDFDFDFDFD5C5BFDFDFDFDFDFDFDFDFDFDFDFDFDFDF7A4FDFD1D1D1D1D
          1D1DFDFDFDFDFD5C1F6FFDFDA4A4A4A4A4A4FDFDFDFDFDF7F7F7FD257737777F
          BF6F1DFDFDFD5C1F6F6FFDF7070707070807A4FDFDFDF7F7070725BF7F37777F
          BF6F261DFD9C1E6F6FFDF708070707070807F7A4FDF7A40707FD25BF7F377777
          A4E4EC9B9B656F6FFDFDF70807070707F7F7F7F7A4F70707FDFD25BF7F3777A4
          09FFFF09EC9B6FFDFDFDF708070707F708F6F608F7F707FDFDFD25BFBFF6E408
          FFFFFFFF09E4FDFDFDFDF7F6F6F60708F6F6F60808F7FDFDFDFD25BF2F2EA4FF
          FFFFFF0909099BFDFDFDF7F6F7F7F7F6F6F6F6080707F7FDFDFD25777F37A4FF
          FFFFFF09EB099BFDFDFDF7070707F7F6F6F6F6070707A4FDFDFD25BF7F37A4F6
          FF09090909099BFDFDFDF7080707F708F60807070807F7FDFDFD25BF7F376DEC
          090909FFF69BFDFDFDFDF7080707F707080707F6F6A4FDFDFDFD25BF7F3777A5
          EC0909F59B9BFDFDFDFDF708070707F7F7070707A4F7FDFDFDFD25BFBF7F7FBF
          B6A49B9BFDFDFDFDFDFDF7080807080807F7A4A4FDFDFDFDFDFD25FFF6F6BFBF
          BFBF7F1DFDFDFDFDFDFDF7FFFFF6F6F6F6F607A4FDFDFDFDFDFDFD25F6F6F6BF
          BFBF1DFDFDFDFDFDFDFDFDF7FFF6F6F6F608F7FDFDFDFDFDFDFDFDFD25252525
          2525FDFDFDFDFDFDFDFDFDFDF7F7F7F7F7F7FDFDFDFDFDFDFDFD}
        NumGlyphs = 2
        ParentFont = False
        TabOrder = 2
        OnClick = btnConsultarClick
      end
    end
    object edtCodigo: TEdit
      Left = 1
      Top = 143
      Width = 191
      Height = 21
      TabStop = False
      AutoSize = False
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 50
      ParentFont = False
      TabOrder = 1
    end
    object Enome: TEdit
      Left = 211
      Top = 143
      Width = 191
      Height = 21
      TabStop = False
      AutoSize = False
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 50
      ParentFont = False
      TabOrder = 2
    end
    object Eunidadde: TEdit
      Left = 421
      Top = 143
      Width = 191
      Height = 21
      TabStop = False
      AutoSize = False
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 50
      ParentFont = False
      TabOrder = 3
    end
    object GroupBox2: TGroupBox
      Left = 3
      Top = 43
      Width = 875
      Height = 83
      Caption = 'Alterar / Incluir / Excluir'
      TabOrder = 4
      object RBalterar: TRadioButton
        Left = 8
        Top = 40
        Width = 55
        Height = 17
        Caption = 'Alterar'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = RBalterarClick
      end
      object RBincluir: TRadioButton
        Left = 88
        Top = 40
        Width = 113
        Height = 17
        Caption = 'Incluir'
        TabOrder = 1
        OnClick = RBincluirClick
      end
      object RBexcluir: TRadioButton
        Left = 159
        Top = 40
        Width = 113
        Height = 17
        Caption = 'Excluir'
        TabOrder = 2
        OnClick = RBexcluirClick
      end
    end
    object Bsalvar: TBitBtn
      Tag = 1
      Left = 618
      Top = 139
      Width = 120
      Height = 22
      Caption = 'Executar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        18000000000000060000120B0000120B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA46769A46769
        A46769A46769A46769A46769A46769A46769A46769A46769A46769A46769A467
        69FF00FFFF00FFFF00FF9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C
        9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9CFF00FFFF00FFFF00FFA46769FCEACE
        F0D8BADCC1A0C4AA89BFA480CFAF82DCB581E2B87EE7BC7EE9BD7FEFC481A467
        69FF00FFFF00FFFF00FF9C9C9CEBEBEBDEDEDECCCCCCB8B8B8B2B2B2BABABABE
        BEBEBFBFBFC1C1C1C2C2C2C6C6C69C9C9CFF00FFFF00FFFF00FFA0675BFEEFDA
        F6E0C6302D2D212527374546998468AD926FC2A074DCB27AE7BC7EEFC481A467
        69FF00FFFF00FFFF00FF959595F0F0F0E5E5E5656565585858777777989898A4
        A4A4AEAEAEBBBBBBC1C1C1C6C6C69C9C9CFF00FFFF00FFFF00FFA0675BFFF4E5
        F7E5CF9C8F800D46630362920B3B544B4741917B5EB5976CD1AB74E9BF7DA467
        69FF00FFFF00FFFF00FF959595F5F5F5E9E9E9A4A4A46A6A6A7676766161617E
        7E7E909090A5A5A5B4B4B4C1C1C19C9C9CFF00FFFF00FFFF00FFA7756BFFFBF0
        F8EADCEEDDCA22576C165E82745D657D52545E3F39867258A78C66CEAA73A065
        67FF00FFFF00FFFF00FF9F9F9FF9F9F9EFEFEFE4E4E47D7D7D7F7F7F82828281
        81816666668888889D9D9DB2B2B2999999FF00FFFF00FFFF00FFA7756BFFFFFC
        FAF0E6F8EADA8F9F9D62555DDD908CB879798E57575B3D377D6B519A815D925C
        5EFF00FFFF00FFFF00FF9F9F9FFEFEFEF3F3F3EEEEEEACACAC949494C4C4C4AD
        ADAD8B8B8B6363638080809393938F8F8FFF00FFFF00FFFF00FFBC8268FFFFFF
        FEF7F2FAEFE6F0E5D56B5D62E9A4A1CF9090B27575875353583C357A69508153
        54FF00FFFF00FFFF00FFA6A6A6FFFFFFF9F9F9F3F3F3E9E9E97E7E7ED1D1D1C0
        C0C0A8A8A88686866161617F7F7F838383FF00FFFF00FFFF00FFBC8268FFFFFF
        FFFEFCFCF6F0FAEFE6EBDCCE8C5E5DE2A1A1CE8F8FB476768652525C3F38764C
        4EFF00FFFF00FFFF00FFA6A6A6FFFFFFFEFEFEF8F8F8F3F3F3E4E4E48D8D8DCF
        CFCFBFBFBFA9A9A98585856464647B7B7BFF00FFFF00FFFF00FFD1926DFFFFFF
        FFFFFFFFFEFCFEF7F0FAEFE5E1CEC0875958E1A1A1CC8E8EB07474865151633B
        3CFF00FFFF00FFFF00FFB1B1B1FFFFFFFFFFFFFEFEFEF9F9F9F3F3F3DBDBDB88
        8888CECECEBEBEBEA7A7A7848484696969FF00FFFF00FFFF00FFD1926DFFFFFF
        FFFFFFFFFFFFFFFEFCFCF7F0FAEFE5D7C1B58A5B5BE6A6A6CA8B8BB675757E44
        423E4145FF00FFFF00FFB1B1B1FFFFFFFFFFFFFFFFFFFEFEFEF8F8F8F3F3F3D2
        D2D28B8B8BD2D2D2BCBCBCAAAAAA7979795C5C5CFF00FFFF00FFDA9D75FFFFFF
        FFFFFFFFFFFFFFFFFFFFFEFCFCF6EFFCF3E6CFB5AA976666EFAAA98C6D731E79
        9F0C98BD0C98BDFF00FFB8B8B8FFFFFFFFFFFFFFFFFFFFFFFFFEFEFEF8F8F8F4
        F4F4CBCBCB969696D7D7D7959595919191909090909090FF00FFDA9D75FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFEFBFFFEF7DAC1BA955F569E5D582D84A706BB
        F0008EDE000F95000081B8B8B8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFDFC
        FCFCD6D6D68D8D8D9292929E9E9E9F9F9F9191917474746A6A6AE7AB79FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDCC7C5A56B5FD1914F068FC10393
        DE0320BA0318B2010B99BFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFDBDBDB999999A3A3A38D8D8D928F92878787848484767676E7AB79FBF4F0
        FBF4EFFAF3EFFAF3EFF8F2EFF7F2EFF7F2EFD8C2C0A56B5FC1836CFF00FF0263
        BF2F45ED1031D3010A95BFBFBFF8F8F8F7F7F7F7F7F7F7F7F7F6F6F6F6F6F6F6
        F6F6D7D7D7999999AAAAAAFF00FF888888BABABA9C9C9C757575E7AB79D1926D
        D1926DD1926DD1926DD1926DD1926DD1926DD1926DA56B5FFF00FFFF00FFFF00
        FF2732D00C19B4FF00FFBFBFBFB1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1
        B1B1B1B1B1999999FF00FFFF00FFFF00FFAAAAAA8C8C8CFF00FF}
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 5
      OnClick = btnAlterarClick
    end
  end
  object GBlistaprodutos: TGroupBox
    Left = 0
    Top = 215
    Width = 910
    Height = 210
    Caption = 'Lista de Produtos'
    TabOrder = 1
    object dbgProduo: TDBGrid
      Left = 2
      Top = 15
      Width = 906
      Height = 193
      Align = alClient
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnCellClick = dbgProduoCellClick
      OnKeyUp = dbgProduoKeyUp
      Columns = <
        item
          Expanded = False
          FieldName = 'CODIGO'
          Title.Caption = 'C'#243'digo'
          Width = 200
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NOME'
          Title.Caption = 'Nome'
          Width = 200
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'UNIDADE'
          Title.Caption = 'Unidade'
          Width = 50
          Visible = True
        end>
    end
  end
  object pnInformativo: TPanel
    Left = 0
    Top = 0
    Width = 926
    Height = 48
    Align = alTop
    Color = clWhite
    TabOrder = 2
    object stTitulo: TStaticText
      Left = 344
      Top = 0
      Width = 125
      Height = 36
      Caption = 'Produtos'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object stDescricao: TStaticText
      Left = 351
      Top = 30
      Width = 105
      Height = 19
      AutoSize = False
      Caption = 'Cadastro de Produtos'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object dsProdutos: TDataSource
    AutoEdit = False
    Left = 385
    Top = 214
  end
end
