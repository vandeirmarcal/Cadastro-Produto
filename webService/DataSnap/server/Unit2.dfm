object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 423
  ClientWidth = 472
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
    Left = 8
    Top = 16
    Width = 129
    Height = 25
    Caption = 'Criando Tipos Json'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 0
    Top = 224
    Width = 472
    Height = 199
    Align = alBottom
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object Button2: TButton
    Left = 8
    Top = 47
    Width = 129
    Height = 25
    Caption = 'Objeto CTE'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 160
    Top = 110
    Width = 129
    Height = 25
    Caption = 'Array 3 elementos'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 160
    Top = 141
    Width = 129
    Height = 25
    Caption = 'array 3 pares 1 objeto'
    TabOrder = 4
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 160
    Top = 172
    Width = 129
    Height = 25
    Caption = 'array 3 '
    TabOrder = 5
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 224
    Top = 16
    Width = 240
    Height = 25
    Caption = ' ler ---Interar JSON'
    TabOrder = 6
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 224
    Top = 47
    Width = 240
    Height = 25
    Caption = ' ler ---Interar JSON array'
    TabOrder = 7
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 8
    Top = 79
    Width = 129
    Height = 25
    Caption = 'Objeto Nota'
    TabOrder = 8
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 8
    Top = 110
    Width = 129
    Height = 25
    Caption = 'Jason CTE 1 Nota'
    TabOrder = 9
  end
  object Button10: TButton
    Left = 328
    Top = 110
    Width = 129
    Height = 25
    Caption = 'teste Guilherme'
    TabOrder = 10
    OnClick = Button10Click
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 176
    Top = 48
  end
end
