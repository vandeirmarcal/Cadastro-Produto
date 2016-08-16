{ ------------------------- INFORMAÇÕES GERAIS ---------------------------------
  bCriterioSql (Representa os critérios SQL)
  Data início: 14/082016

  Vandeir Roberto Marçal
 ----------------------------------------------------------------------------- }

unit pMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, pCadProdutos;

type
  TFMenu = class(TForm)
    mmMenu: TMainMenu;
    Matriz1: TMenuItem;
    Mprodutos: TMenuItem;
    N4: TMenuItem;
    mSait: TMenuItem;
    procedure MprodutosClick(Sender: TObject);
    procedure mSaitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMenu: TFMenu;



implementation

{$R *.dfm}

procedure TFMenu.MprodutosClick(Sender: TObject);
begin
  Application.CreateForm(TFcadprodutos, Fcadprodutos);
  Fcadprodutos.ShowModal;
end;

procedure TFMenu.mSaitClick(Sender: TObject);
begin

  // Fecho a tela
  close;
end;

end.
