{ ------------------------- INFORMA��ES GERAIS ---------------------------------
  bSelect (Representa uma consulta SQL - SELECT)
  Data in�cio: 13/06/2016

  Vandeir Roberto Mar�al
  AJI - Sistemas
 ----------------------------------------------------------------------------- }
unit bDelete;

interface

 uses DBClient, Classes, bCriterioSql,IBX.IBQuery,IBX.IBDataBase,pDataModule;

 type TDelete = class (TCriterio)
   private
     { --------------------------- ATRIBUTOS --------------------------------- }


   protected

   public

     { -------------------------- GERAL -------------------------------------- }

     {
      Constr�i uma consulta SQL

      Return:
          a consulta SQL
     }
     function buildSQL  : string;  override;
 end;

implementation

uses
 sysutils;

function TDelete.buildSQL : string;

var i : integer;
    sql : string;

begin

  // Herda
  Result := '';
  i := 0;

  // SELECT
  sql := 'DELETE FROM ';

  // TABELAS
  for i:=0 to tabelas.Count-2 do begin

    sql := sql + montaTabela(i)+ ',';
  end;

  sql := sql + montaTabela(i);

  // Verifico se exist crit�rio
  if (Length(criterio) > 0) then
  begin
    sql := sql + ' WHERE ' + buildCriterio;
  end;

  // Guarda para pr�ximo BUILD
  Result := sql;
end;



end.
