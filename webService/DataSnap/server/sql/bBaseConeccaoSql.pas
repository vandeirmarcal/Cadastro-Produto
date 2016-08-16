{ ------------------------- INFORMAÇÕES GERAIS ---------------------------------
  bBaseConeccaoSql (Comunicação com banco de dados)
  Data : 13/06/2016

  Vandeir Roberto Marçal
  AJI - Sistemas
 ----------------------------------------------------------------------------- }
unit bBaseConeccaoSql;

interface

  uses SysUtils,DB;

 { ------------------------- DESCRIÇÃO DA CLASSE ----------------------------- }

 {
  ==============================================================================
  BASE COMUNICAÇÃO COM BANCO DE DADOS
  ==============================================================================

 }

type
  TBaseConeccaoSql = class

   protected

     { --------------------------- CONEXÃO ----------------------------------- }

     { -- ESTRUTURA --
    	ClientDataSet utilizado para geração de identificadores
     }
     cds: TDataSet;

     { -- DADO --
      Login do usuário no sistema
     }
     login : string;

     { -- DADO --
      No do banco que será conectado
     }
     banco : string;

     { -- DADO --
      Senha do banco de dados
     }
     senha : string;

   protected
     { --------------------------- ATRIBUTOS --------------------------------- }


   public
     { ------------------------ MANUTENÇÃO OBJETOS --------------------------- }

     {
      Executa comandos SQL que não retornam cursor (INSERT, UPDATE, etc)

      Parameters:
          sql - comando sql

      Return:
          o número de registros afetados

      Exceptions:
   				EFileLog   - erro genérico
   				ETratDBLog - erro de banco que pode ser tratado
     }
     function execSQL (sql: string) : integer; overload; virtual; abstract;

     {
      Executa comandos SQL com parâmetros e que não retornam cursor
      (INSERT, UPDATE, etc)

      Parameters:
          sql - comando sql
          params - o objeto TParams contendo os valores dos parâmetros

      Return:
          o número de registros afetados

      Exceptions:
   				EFileLog   - erro genérico
   				ETratDBLog - erro de banco que pode ser tratado
     }
     function execSQL (sql: string; params : TParams):integer; overload;
                                                      virtual; abstract;

  end;

implementation

uses Math, typinfo,  Classes,   DateUtils;

function TBaseConeccaoSql.paramSQL (sql: string; params : TParams) : string;

var dado, sql2 : string ;
    i : integer;

begin

  // Se tiver parametros altera consulta SQL
  sql2 := sql;
  if (params <> nil) then
  begin
    for i := 0 to params.Count-1 do
    begin

      // Padrão string
      dado := params[i].AsString;

      // Converte se necessário
      if (params[i].DataType = ftFloat) then
      begin

//        dado := TBaseConeccaoSql.toDouble(params[i].AsFloat);
      end;

      if (params[i].DataType = ftInteger) then
      begin

        dado := IntToStr(params[i].AsInteger);
      end;

      if (params[i].DataType = ftDate) then
      begin

        //dado := '"'+TBaseSQL.toDate(params[i].AsDate)+'"';
      end;

      if (params[i].DataType = ftDateTime) then
      begin

        //dado := '"'+TBaseSQL.toDateTime(params[i].AsDateTime)+'"';
      end;

      // Troca SQL
      sql2 := StringReplace(sql2,':'+params[i].Name,dado,[]);
    end;
  end;

  // Escreve no log
  Result := sql2;
end;

end.


