{ ------------------------- INFORMA��ES GERAIS ---------------------------------
  bBaseSql (Classe base para SQL)
  13/06/2016

  Avisos:
  Vandeir Roberto Mar�al
  AJI - Sistemas
 ----------------------------------------------------------------------------- }
unit bBaseSql;

interface

uses DBClient, IBX.IBQuery, Classes, dialogs, IBX.IBDataBase,pDataModule;

 type regCriterio = record
   nomeCampo   : string;
   valorCampo  : string;
   parametro   : string;
   operador    : string;
   condicional : string;
 end;

 type regCampo = record
   nomeCampo   : string;
   valorCampo  : Variant;
   parametro   : string;
 end;

 type TBaseSQL = class (TPersistent)
   private

   protected
     { --------------------------- ATRIBUTOS --------------------------------- }

     { -- ESTRUTURA --
      Tabelas do sql
     }
     tabelas : TStringList;

     { -- ESTRUTURA --
     SQL batch
     }
     lista_sql : TStringList;

     { -- ESTRUTURA --
      Registro de Crit�rios
     }
     criterio : array of regCriterio;

     { -- ESTRUTURA --
      Registro de Campo
     }
     campo : array of regCampo;

     { -- ESTRUTURA --
      Estrutura que guarda a Query
     }
     Script : TIBQuery;

     { ---------------------------- CONVERTE --------------------------------- }

     {
      Acessa todos os SQL Lazy armazenados (batch)

      Parameters:
          comunica��o banco de dados

      Return:
          qtde total de registros processados
     }
     function buildTabelas : string;

     function montaTabela(i : integer) : string;

     {
      Monta o campo, que pode ser um nome ou um SQL

      Parameters:
          i - posi��o do campo

      Return:
          o campo montado
     }
     function montaColuna(i : integer) : string;



   public
     { ------------------------ MANUTEN��O OBJETOS --------------------------- }


     constructor Create; overload; virtual;

     destructor Destroy  ;  override;

     {
      Constr�i a consulta SQL ou parte dela

      Return:
          a consulta SQL
     }
     function buildSQL : string; virtual;abstract;

     procedure addColuna (nome : string);overload;

     {
      Adiciona uma nova tabela

      Parameters:
          nome - nome da tabela a ser adicionada
          alias - apelido para a tabela
     }
     procedure addTable (nome,alias : string) ; overload ;



     {                                                             .
      Limpa as estruturas internas da classe preparando o objeto para ser
      utilizado novamente, sem a necessidade de liberar e criar o objeto
      novamente.
     }
     procedure Clear; virtual;

     {

     }
     function Execute : integer;overload;virtual;
 end;

implementation

uses Sysutils, DateUtils;

// -------------------------------------------------------------------------- //
// --------------------------- MANUTEN��O OBJETOS --------------------------- //
// -------------------------------------------------------------------------- //

Constructor TBaseSQL.Create;

begin
  inherited;

  tabelas := TStringList.Create;

  // Lista SQL
  lista_sql := TStringList.Create;

  Script := TIBQuery.Create(Nil);
end;

Destructor TBaseSQL.Destroy ;
begin

  // Destruo os objetos
  lista_sql.Free;

  // Herdo a logica padrao
  inherited;
end;

procedure TBaseSQL.Clear;
begin

  tabelas.Clear;
  lista_sql.Clear;
  SetLength(criterio,0);
  SetLength(campo,0);
end;

function TBaseSQL.buildTabelas : string;

var i : integer;
    sql : string;

begin

  sql := tabelas.Strings[i];

  // Retorno
  Result := sql;
end;

function TBaseSQL.montaTabela(i : integer) : string;

var sql : string;

begin

  sql := tabelas.Strings[i];

  // Retorno
  Result := sql;
end;

function TBaseSQL.Execute : integer;

Var i : Integer;

begin

  Try
    Try
      with Script do
      begin
        Database := UdmParame.ciGtrans;

        if not(Transaction.InTransaction) then
        begin
          Transaction.StartTransaction;
        end;

        Close;
        Prepared := False;
        SQL.Clear;
        SQL.Add(buildSQL);

        for i := 0 to Length(campo)-1 do
        begin
          ParamByName(campo[i].parametro).AsString := campo[i].valorCampo;
        end;

        for i := 0 to Length(criterio)-1 do
        begin
          ParamByName(criterio[i].parametro).AsString := criterio[i].valorCampo;
        end;

        Prepared := True;
        ExecSQL;

        if (Transaction <> Nil) then
        begin
          Transaction.Commit;
        end;
      end;

    except on E:Exception do
      Begin
        {if bMsg then
        begin
          MsgErro(PChar('N�o foi poss�vel efetuar a atualiza��o do registro.' + #13 +
                        'Erro: ' + dmParame.VerificaErro(E.Message) + #13 +
                        'Origem: ' + E.Message));
        end; }
        Abort;
      end;
    End;
  Finally
//    FecharDestruirDataSet(Script);
  End;

End;

function TBaseSQL.montaColuna(i : integer) : string;

var sql : string;

begin


  sql := campo[i].nomeCampo;

  // Retorno
  Result := sql;
end;

procedure TBaseSql.addColuna (nome : string);

var tamanho : integer;

begin

  tamanho := Length(campo);

  // Adiciono uma posi��o na estrutura
  SetLength(campo,tamanho+1);

  // Monto o crit�rio
  campo[tamanho].nomeCampo   := nome;
  campo[tamanho].parametro   := 'p'+nome;
  campo[tamanho].valorCampo  := nome;
end;

procedure TBaseSql.addTable(nome,alias : string);
begin
  tabelas.Add(nome+' '+alias);
end;


end.
