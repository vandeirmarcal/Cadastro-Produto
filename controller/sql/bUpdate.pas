{ ------------------------- INFORMA��ES GERAIS ---------------------------------
  bSelect (Representa uma consulta SQL - SELECT)
  Data in�cio: 13/06/2016

  Vandeir Roberto Mar�al
  AJI - Sistemas
 ----------------------------------------------------------------------------- }
unit bUpdate;

interface

 uses DBClient, Classes, bCriterioSql,IBX.IBQuery,IBX.IBDataBase,pDataModule;

 type TUpdate = class (TCriterio)
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

     procedure addColuna (nome: string; valor : variant);overload;

 end;

implementation

uses
 sysutils;

function TUpdate.buildSQL : string;

var i : integer;
    sql : string;

begin

  // Herda
  Result := '';

  // SELECT
  sql := 'UPDATE ';

  // TABELAS
  for i:=0 to tabelas.Count-2 do begin

    sql := sql + montaTabela(i) + ',';
  end;

  // �ltimo campo
  sql := sql + montaTabela(tabelas.Count-1)+' SET ';

  // CAMPOS
  for i:=0 to Length(campo)-2 do
  begin

    sql := sql + campo[i].nomeCampo+' = :'+campo[i].parametro+', ';
  end;

  // �ltimo campo
  sql := sql + campo[i].nomeCampo+' = :'+campo[i].parametro+'';

  // Verifico se exist crit�rio
  if (Length(criterio) > 0) then
  begin
    sql := sql + ' WHERE ' + buildCriterio;
  end;

  // Guarda para pr�ximo BUILD
  Result := sql;
end;

procedure TUpdate.addColuna (nome: string; valor : variant );

var tamanho : integer;

begin

  tamanho := Length(campo);

  // Adiciono uma posi��o na estrutura
  SetLength(campo,tamanho+1);

  // Monto o crit�rio
  campo[tamanho].nomeCampo   := nome;
  campo[tamanho].parametro   := 'p'+nome;
  campo[tamanho].valorCampo  := valor;
end;


end.
