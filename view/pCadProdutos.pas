{ ------------------------- INFORMAÇÕES GERAIS ---------------------------------
  pCadProdutos (Tela responsável pelo cadastro de prodtos)
  14/08/2016

  Avisos:
  Vandeir Roberto Marçal
 ----------------------------------------------------------------------------- }
unit pCadProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, dbclient, bSelect, bCriterioSql, bCadPrdutos;

type
  TFcadprodutos = class(TForm)
    pnBotoesAcao: TPanel;
    GBlistaprodutos: TGroupBox;
    dbgProduo: TDBGrid;
    Loperacao: TLabel;
    pnInformativo: TPanel;
    stTitulo: TStaticText;
    stDescricao: TStaticText;
    dsProdutos: TDataSource;
    GBconsulta: TGroupBox;
    CBconsulta: TComboBox;
    Econsulta: TEdit;
    BitBtn1: TBitBtn;
    edtCodigo: TEdit;
    Enome: TEdit;
    Eunidadde: TEdit;
    Lcodigo: TLabel;
    Lnome: TLabel;
    Lunidade: TLabel;
    GroupBox2: TGroupBox;
    RBalterar: TRadioButton;
    RBincluir: TRadioButton;
    RBexcluir: TRadioButton;
    Bsalvar: TBitBtn;
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dbgProduoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgProduoCellClick(Column: TColumn);
    procedure BcancelarClick(Sender: TObject);
    procedure CBconsultaCloseUp(Sender: TObject);
    procedure RBalterarClick(Sender: TObject);
    procedure RBincluirClick(Sender: TObject);
    procedure RBexcluirClick(Sender: TObject);
  private

    { -- ESTRUTURA --
     Objeto que representa a classe de negócios
    }
    bCadPrdutos : TCadProdutos;
    codigo : string;
    nome : string;
    unidade : string;
  public
    { Public declarations }
  end;

var
  Fcadprodutos: TFcadprodutos;

implementation

{$R *.dfm}

procedure TFcadprodutos.BcancelarClick(Sender: TObject);
begin

  // Atualizo o grid
  btnConsultarClick(self);
end;

procedure TFcadprodutos.btnAlterarClick(Sender: TObject);
begin

  if RBalterar.Checked then
  begin

    // Atualizo a tela
    Loperacao.Caption := 'Alteração';

    if (dbgProduo.DataSource.DataSet.FieldByName('CODIGO').AsString  = EmptyStr) then
     begin
      ShowMessage('Produto Inexistente!');
      dbgProduo.SetFocus;

      exit;
    end;

    // Aaltero os dados no banco de dados
    bCadPrdutos.updateProduto(Enome.Text, Eunidadde.Text, edtCodigo.Text);
  end else
  begin
    if RBexcluir.Checked then
    begin

      // Atualizo a tela
      Loperacao.Caption := 'Exclusão';

      if (dbgProduo.DataSource.DataSet.FieldByName('CODIGO').AsString  = EmptyStr) then
      begin
        ShowMessage('Produto Inexistente!');
        dbgProduo.SetFocus;

        exit;
      end;

      // Excluo o produto
      bCadPrdutos.deleteProduto;
    end else
    begin

      // Atualizo a tela
      Loperacao.Caption := 'Inclusão';

      if (edtCodigo.Text  = EmptyStr) then
       begin
        ShowMessage('Produto Inexistente!');
        dbgProduo.SetFocus;

        exit;
      end;

      // Incluo o produto
      bCadPrdutos.insereProduto(Enome.Text, Eunidadde.Text, edtCodigo.Text);
    end;
  end;

  // Atualizo o grid
  btnConsultarClick(self);
end;

procedure TFcadprodutos.btnConsultarClick(Sender: TObject);
begin

  // Atualizo a tela
  Loperacao.Caption := 'Consulta';

  if (CBconsulta.ItemIndex = 0) then
  begin
    Econsulta.Clear;
  end;

  case CBconsulta.ItemIndex of
    0 : Econsulta.Clear;

    1 :
    begin
      if Econsulta.Text = EmptyStr then
      begin
        ShowMessage('Necessário inserir um código');
        Econsulta.SetFocus;
      end;
    end;

    2 :
    begin
      if Econsulta.Text = EmptyStr then
      begin
        ShowMessage('Necessário inserir um Nome');
        Econsulta.SetFocus;
      end;
    end;

  end;

  // Carrego o DataSource co tdos os produtos
  dsProdutos.DataSet := bCadPrdutos.loadProdutos(CBconsulta.ItemIndex,Econsulta.Text,codigo, nome, unidade);

  // Ligo o grid no dataSource
  dbgProduo.DataSource := dsProdutos;

  edtCodigo.Text := dbgProduo.DataSource.DataSet.FieldByName('CODIGO').AsString;
  Enome.Text     := dbgProduo.DataSource.DataSet.FieldByName('NOME').AsString;
  Eunidadde.Text := dbgProduo.DataSource.DataSet.FieldByName('UNIDADE').AsString
end;

procedure TFcadprodutos.btnIncluirClick(Sender: TObject);
begin

  // Atualizo a tela
  Loperacao.Caption := 'Inclusão';

  if (dbgProduo.DataSource.DataSet.FieldByName('CODIGO').AsString  = EmptyStr) then
   begin
    ShowMessage('Produto Inexistente!');
    dbgProduo.SetFocus;

    exit;
  end;


  // Incluo o produto
  bCadPrdutos.insereProduto(Enome.Text, Eunidadde.Text, edtCodigo.Text);

  // Atualizo o grid
  btnConsultarClick(self);
end;

procedure TFcadprodutos.CBconsultaCloseUp(Sender: TObject);
begin
  case CBconsulta.ItemIndex of

    0 :
    begin
      Econsulta.Clear;
      Econsulta.Enabled := False;
    end;
    1 :
    begin
      Econsulta.Enabled := True;
      Econsulta.SetFocus;
    end;
    2 :
    begin
      Econsulta.Enabled := True;
      Econsulta.SetFocus;
    end;
  end;
end;

procedure TFcadprodutos.dbgProduoCellClick(Column: TColumn);
begin
  edtCodigo.Text := dbgProduo.DataSource.DataSet.FieldByName('CODIGO').AsString;
  Enome.Text     := dbgProduo.DataSource.DataSet.FieldByName('NOME').AsString;
  Eunidadde.Text := dbgProduo.DataSource.DataSet.FieldByName('UNIDADE').AsString
end;

procedure TFcadprodutos.dbgProduoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  edtCodigo.Text := dbgProduo.DataSource.DataSet.FieldByName('CODIGO').AsString;
  Enome.Text     := dbgProduo.DataSource.DataSet.FieldByName('NOME').AsString;
  Eunidadde.Text := dbgProduo.DataSource.DataSet.FieldByName('UNIDADE').AsString
end;

procedure TFcadprodutos.FormCreate(Sender: TObject);
begin

  // Crio objeto
  bCadPrdutos := TCadProdutos.Create;

  // Carrego o DataSource co tdos os produtos
  dsProdutos.DataSet   := bCadPrdutos.loadProdutos(0,'', codigo, nome, unidade);

  // Ligo o grid no dataSource
  dbgProduo.DataSource := dsProdutos;

  edtCodigo.Text := dbgProduo.DataSource.DataSet.FieldByName('CODIGO').AsString;
  Enome.Text     := dbgProduo.DataSource.DataSet.FieldByName('NOME').AsString;
  Eunidadde.Text := dbgProduo.DataSource.DataSet.FieldByName('UNIDADE').AsString;
end;

procedure TFcadprodutos.RBalterarClick(Sender: TObject);
begin
  edtCodigo.SetFocus;

  edtCodigo.ReadOnly := False;
  Enome.ReadOnly     := False;
  Eunidadde.ReadOnly := False;
end;

procedure TFcadprodutos.RBexcluirClick(Sender: TObject);
begin
  dbgProduo.SetFocus;

  edtCodigo.Text := dbgProduo.DataSource.DataSet.FieldByName('CODIGO').AsString;
  Enome.Text     := dbgProduo.DataSource.DataSet.FieldByName('NOME').AsString;
  Eunidadde.Text := dbgProduo.DataSource.DataSet.FieldByName('UNIDADE').AsString;

  edtCodigo.ReadOnly := True;
  Enome.ReadOnly     := True;
  Eunidadde.ReadOnly := True;
end;

procedure TFcadprodutos.RBincluirClick(Sender: TObject);
begin
  edtCodigo.ReadOnly := False;
  Enome.ReadOnly     := False;
  Eunidadde.ReadOnly := False;

  edtCodigo.Clear;
  Enome.Clear;
  Eunidadde.Clear;

  edtCodigo.SetFocus;
end;

end.
