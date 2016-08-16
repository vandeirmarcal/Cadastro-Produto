{ ------------------------- INFORMA��ES GERAIS ---------------------------------
  bBaseConeccaoSql (Comunica��o com banco de dados)
  Data : 13/06/2016

  Vandeir Roberto Mar�al
  AJI - Sistemas
 ----------------------------------------------------------------------------- }
unit bBaseConeccaoSql;

interface

  uses SysUtils,DB;

 { ------------------------- DESCRI��O DA CLASSE ----------------------------- }

 {
  ==============================================================================
  BASE COMUNICA��O COM BANCO DE DADOS
  ==============================================================================

 }

type
  TBaseConeccaoSql = class

   protected

     { --------------------------- CONEX�O ----------------------------------- }

     { -- ESTRUTURA --
    	ClientDataSet utilizado para gera��o de identificadores
     }
     cds: TDataSet;

     { -- DADO --
      Login do usu�rio no sistema
     }
     login : string;

     { -- DADO --
      No do banco que ser� conectado
     }
     banco : string;

     { -- DADO --
      Senha do banco de dados
     }
     senha : string;

   protected
     { --------------------------- ATRIBUTOS --------------------------------- }


   public
     { ------------------------ MANUTEN��O OBJETOS --------------------------- }

     {
      Executa comandos SQL que n�o retornam cursor (INSERT, UPDATE, etc)

      Parameters:
          sql - comando sql

      Return:
          o n�mero de registros afetados

      Exceptions:
   				EFileLog   - erro gen�rico
   				ETratDBLog - erro de banco que pode ser tratado
     }
     function execSQL (sql: string) : integer; overload; virtual; abstract;

     {
      Executa comandos SQL com par�metros e que n�o retornam cursor
      (INSERT, UPDATE, etc)

      Parameters:
          sql - comando sql
          params - o objeto TParams contendo os valores dos par�metros

      Return:
          o n�mero de registros afetados

      Exceptions:
   				EFileLog   - erro gen�rico
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

      // Padr�o string
      dado := params[i].AsString;

      // Converte se necess�rio
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


