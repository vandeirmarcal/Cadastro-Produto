object FMenu: TFMenu
  Left = 0
  Top = 0
  Caption = 'Software de Cadastro'
  ClientHeight = 361
  ClientWidth = 783
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mmMenu
  OldCreateOrder = False
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 13
  object mmMenu: TMainMenu
    Left = 112
    Top = 168
    object Matriz1: TMenuItem
      Caption = 'Cadastros'
      object Mprodutos: TMenuItem
        Tag = 6
        Caption = 'Produtos'
        OnClick = MprodutosClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
    end
    object mSait: TMenuItem
      Caption = 'Sai&r'
      Hint = 'Sai do Sistema'
      OnClick = mSaitClick
    end
  end
end
