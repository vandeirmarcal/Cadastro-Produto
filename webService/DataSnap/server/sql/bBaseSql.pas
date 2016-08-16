{ ------------------------- INFORMAÇÕES GERAIS ---------------------------------
  bBaseSql (Classe base para SQL)
  13/06/2016

  Avisos:
  Vandeir Roberto Marçal
  AJI - Sistemas
 ----------------------------------------------------------------------------- }
unit bBaseSql;

interface

 uses DB, IBX.IBQuery, Classes, dbClient, dialogs, IBX.IBDataBase;

 type regCriterio = record
   nomeCampo   : string;
   valorCampo  : string;
   parametro   : string;
   operador    : string;
   condicional : string;
 end;

 type TBaseSQL = class (TPersistent)
   private
     { --------------------------- ATRIBUTOS --------------------------------- }

     {
      Converte uma data (TDateTime) em uma string no formato FIREBIRD
      (DD.MM.YYYY)

      Parameters:
          data - a data a ser convertida

      Return:
          a string contendo a data
     }
     class function toDateMySQL (const data : TDateTime) : string;

     {
      Converte um valor em uma string no formato ('99.99')

      Parameters:
          valor - o valor a ser convertida

      Return:
          a string contendo o valor
     }
     class function toDoubleMySQL (const valor : double) : string;

   protected
     { --------------------------- ATRIBUTOS --------------------------------- }

     criterio : array of regCriterio;

     { -- ESTRUTURA --
     Parâmetro, caso necessário
     }
     params : TParams;

     { -- ESTRUTURA --
     Contém todos os campos da consulta SQL
     }
     coluna : TStringList;

     { -- ESTRUTURA --
      Tabelas do sql
     }
     tabelas : TStringList;

     { -- ESTRUTURA --
     Owner
     }
     owner : TObject;

     { -- ESTRUTURA --
     SQL batch
     }
     lista_sql : TStringList;

     { -- DADO --
     Executa SQL ?
     }
     executa : boolean;

     { -- DADO --
     Último parâmetro
     }
     ultParam : string;

     { -- DADO --
     Se precisar utiliza parâmetros para montar a consulta, não é necessário
     inserior os dados, os nomes dos parâmetros deve ser o mesmo que os nomes
     dos campos
     }
     is_params : boolean;

     { ---------------------------- CONVERTE --------------------------------- }


     {
      Acessa todos os SQL Lazy armazenados (batch)

      Parameters:
          comunicação banco de dados

      Return:
          qtde total de registros processados
     }
     function buildTabelas : string;

     function montaTabela(i : integer) : string;


   public
     { ------------------------ MANUTENÇÃO OBJETOS --------------------------- }


     constructor Create; overload; virtual;

     destructor Destroy  ;  override;

     {
      Constrói a consulta SQL ou parte dela

      Return:
          a consulta SQL
     }
     function buildSQL : string; virtual;

     {                                                             .
      Limpa as estruturas internas da classe preparando o objeto para ser
      utilizado novamente, sem a necessidade de liberar e criar o objeto
      novamente.
     }
     procedure Clear; virtual;

     {
      Executa a consulta utilizando a conexão geral (conn.execSQL). A classe
      filha SELECT que retorna cursor devem re-implementar este método.

      Return:
          o número de registros afetados
     }
     function Execute(sqlMontada : string) : TClientDataSet;

     {
      Indica se vai utilizar parâmetros ou não
     }
     procedure useParam;

     { ---------------------------- CONVERTE --------------------------------- }

     {
      Converte uma data (TDateTime) em uma string com DATA

      Parameters:
          data - a data a ser convertida

      Return:
          a string contendo a data
     }
     class function toDate (const data : TDateTime) : string;

     {
      Converte um valor (Double) em uma string no formato do BD utilizado

      Parameters:
          valor - o valor a ser convertido

      Return:
          a string contendo o valor
     }
     class function toDouble (const valor : double) : string;

     { ------------------------- PROPRIEDADES -------------------------------- }

     property setExec : boolean read executa write executa;

     property getParam : TParams read params;

     {
      Injetar Owner
     }
     property setOwner : TObject write owner;
 end;

implementation

uses Sysutils, DateUtils, pDataModule, UFuncoes;

// -------------------------------------------------------------------------- //
// --------------------------- MANUTENÇÃO OBJETOS --------------------------- //
// -------------------------------------------------------------------------- //


Constructor TBaseSQL.Create;

begin
  inherited;

  // Params
  params := TParams.Create;

  tabelas := TStringList.Create;

  // Lista SQL
  lista_sql := TStringList.Create;

  // Nada
  owner := nil;

  // Não utiliza parâmetros...
  is_params := false;

  // Sempre executa
  executa := true;
end;

Destructor TBaseSQL.Destroy ;

begin
  params.Free;
  lista_sql.Free;

  inherited;
end;

procedure TBaseSQL.Clear;

begin

  // Parâmetros
  is_params := false;
  params.Clear;
end;

function TBaseSQL.buildSQL : string;

begin

  Result := '';
end;

function TBaseSQL.Execute(sqlMontada : string) : TClientDataSet;

Var
  Consulta : TIBQuery;
  ConsultaCDS : TClientDataSet;
  iCont : Integer;
  i     : integer;
  transacao :  TIBTransaction;

Begin
  Try
    try
      Consulta := TIBQuery.Create(Nil);
      with Consulta do
      begin

        Database := UdmParame.ciGtrans;

        //        transacao := criartransacao(database);
//        Transaction := transacao;
//       Close;

        SQL.Clear;
        SQL.Add(sqlMontada);

        for i := 0 to Length(criterio) - 1 do
        begin
          ParamByName(criterio[i].parametro).Value := criterio[i].valorCampo;
        end;

        Open;

        last;
        First;
      end;
    except on E: Exception do
      Begin
        FecharDestruirDataSet(Consulta);
        Abort;
      End;
    end;

    ConsultaCDS := TClientDataSet.Create(nil);
    with Consulta do
    Begin
      For iCont := 0 to Fields.Count-1 do
      Begin
        ConsultaCDS.FieldDefs.Add(Fields[iCont].FieldName,
                                  Fields[iCont].DataType,
                                  Fields[iCont].Size,
                                  False);
      End;
      ConsultaCDS.CreateDataSet;
      While not eof do
      Begin
        ConsultaCDS.Append;
        For iCont := 0 to Fields.Count-1 do
        Begin
          ConsultaCDS.Fields[iCont].Value := Fields[iCont].Value;
        End;
        ConsultaCDS.Post;
        Next;
      End;
    End;
    FecharDestruirDataSet(Consulta);
    ConsultaCDS.Open;
    ConsultaCDS.First;
    Result := ConsultaCDS;
  except on E: Exception do
    Begin
      FecharDestruirDataSet(Consulta);
      if ConsultaCDS <> Nil then
      Begin
        ConsultaCDS.Close;
        FreeAndNil(ConsultaCDS);
      End;
      Abort;
    End;
  end;
End;

function TBaseSQL.buildTabelas : string;

var i : integer;
    sql : string;

begin

  sql := tabelas.Strings[i];

  // Retorno
  Result := sql;
end;

procedure TBaseSQL.useParam;

begin
  is_params := true;
end;

class function TBaseSQL.toDateMySQL (const data : TDateTime) : string;

var day,month,year : Word;
    smonth, sday : string;

begin
  // Separa dia, mês e ano
  DecodeDate(data, year, month, day);

  // Mês
  if (month < 10) then
  begin

    smonth := '0' + IntToStr(month);
  end else
  begin

    smonth := IntToStr(month);
  end;

  // Dia
  if (day < 10) then
  begin

    sday := '0' + IntToStr(day);
  end else
  begin

    sday := IntToStr(day);
  end;

  Result := sday+'.'+smonth+'.'+IntToStr(year);
end;

class function TBaseSQL.toDoubleMySQL (const valor : double) : string;

var texto : string;

begin
  texto := FloatToStr(valor);

  if (Pos(',',texto) <> 0) then texto[Pos(',',texto)] := '.';
  Result := texto;
end;

// -------------------------------------------------------------------------- //
// --------------------------- CONVERTE ------------------------------------- //
// -------------------------------------------------------------------------- //

class function TBaseSQL.toDate (const data : TDateTime) : string;

begin
  Result := toDateMySQL (data);
end;

class function TBaseSQL.toDouble (const valor : double) : string;

begin
  Result := toDoubleMySQL (valor);
end;

function TBaseSQL.montaTabela(i : integer) : string;

var sql : string;

begin

  sql := tabelas.Strings[i];

  // Retorno
  Result := sql;
end;


end.
