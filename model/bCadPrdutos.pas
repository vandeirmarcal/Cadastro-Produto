{ ------------------------- INFORMAÇÕES GERAIS ---------------------------------
  pCadProdutos (Classe responsável pela lógica de negócios)
  14/08/2016

  Avisos:
  Vandeir Roberto Marçal
 ----------------------------------------------------------------------------- }

unit bCadPrdutos;

interface

uses dbclient, bSelect, bInsert, bUpdate, bDelete;

type
  TCadProdutos = class
  private

    { -- ESTRUTURA --
     CDS Produto
    }
    cdsProd : TClientDataSet;

    { -- ESTRUTURA --
     Objeto responsável por executar consultas no banco de dados
    }
    select : TSelect;

    { -- ESTRUTURA --
     Objeto responsável por executar alteraçoes no banco de dados
    }
    update : TUpdate;

    { -- ESTRUTURA --
     Objeto responsável por inserçao alteraçoes no banco de dados
    }
    insert : TInsert;

    { -- ESTRUTURA --
     Objeto responsável por deletar no banco de dados
    }
    delete : TDelete;
  public

    {
      Construtor
    }
    constructor create;

    {
      Destroi objeto
    }
    destructor destroy;

    {
     Carrego os produtos

       Parametros :
         tipo - tipo do campo que será chave da cosulta
           0 - Todos os produtos
           1 - nome
           2 - codigo

       Retorna :
         Cliente DataSet com os produtos consultados
    }
    function loadProdutos(tipo : integer; campo : string ;var codigo, nome,
                          unidade : String) : TClientDataSet;

    {
     Insere os produtos

       Parametros :
         tipo - tipo do campo que será chave da cosulta
           0 - Todos os produtos
           1 - nome
           2 - codigo

       Retorna :
         True  - Dado inserido com sucesso
         False - Dado nao inserido com sucesso
    }
    function insereProduto(nome, unidade, codigo : String) : boolean;

    {
     Atualizaçao dos produtos

       Parametros :
         tipo - tipo do campo que será chave da cosulta
           0 - Todos os produtos
           1 - nome
           2 - codigo

       Retorna :
         True  - Dado inserido com sucesso
         False - Dado nao inserido com sucesso
    }
    function updateProduto(nome, unidade, codigo : String) : boolean;

    {
     Remoçao dos produtos

       Parametros :
         tipo - tipo do campo que será chave da cosulta
           0 - Todos os produtos
           1 - nome
           2 - codigo

       Retorna :
         True  - Dado inserido com sucesso
         False - Dado nao inserido com sucesso
    }
    function deleteProduto : boolean;

  end;

implementation

constructor TCadProdutos.create;
begin

  inherited;

  // Crio objeto
  select := TSelect.Create;
  update := TUpdate.Create;
  insert := TInsert.Create;
  delete := tdelete.create
end;

destructor TCadProdutos.destroy;
begin

  // Destruo objeto
  select.Free;
  update.Free;
  insert.Free;
  delete.Free;

  inherited;
end;

function TCadProdutos.loadProdutos(tipo : integer; campo : string ;var codigo, nome,
                          unidade : String) : TClientDataSet;
begin

  // Limpo objeto
  select.Clear;
  select.addColuna('*');
  select.addTable('PRODUTO', '');

  case tipo of
    1: select.addCriterio('CODIGO',campo,'=');
    2: select.addCriterio('NOME','%'+campo+'%','LIKE');
  end;
  select.Execute(cdsProd);

  Result := cdsProd;

  codigo  := cdsProd.FieldByName('CODIGO').AsString;
  nome    := cdsProd.FieldByName('NOME').AsString;
  unidade := cdsProd.FieldByName('UNIDADE').AsString;
end;

function TCadProdutos.insereProduto(nome, unidade, codigo : String) : boolean;
begin
  insert.Clear;
  insert.addColuna('NOME', nome);
  insert.addColuna('UNIDADE', unidade);
  insert.addColuna('CODIGO', codigo);
  insert.addTable('PRODUTO', '');
  insert.Execute;
end;

function TCadProdutos.updateProduto(nome, unidade, codigo : String) : boolean;
begin

  update.Clear;
  update.addColuna('NOME', nome);
  update.addColuna('UNIDADE', unidade);
  update.addColuna('CODIGO', codigo);
  update.addCriterio('ID_PRODUTO', cdsProd.FieldByName('ID_PRODUTO').AsString, '=');
  update.addTable('PRODUTO', '');
  update.Execute;
end;

function TCadProdutos.deleteProduto : boolean;
begin
  delete.Clear;
  delete.addTable('PRODUTO', '');
  delete.addCriterio('ID_PRODUTO', cdsProd.FieldByName('ID_PRODUTO').AsString, '=');
  delete.Execute;
end;

end.
