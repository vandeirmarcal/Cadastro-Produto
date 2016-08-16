{ ------------------------- INFORMA��ES GERAIS ---------------------------------
  bCriterioSql (Representa os crit�rios SQL)
  Data in�cio: 14/082016

  Vandeir Roberto Mar�al
 ----------------------------------------------------------------------------- }
unit bCriterioSql;

interface

USES bBaseSql;

 type TCriterio = class (TBaseSql)
   private

   protected

   public
     { -----------------------  MANUTEN��O OBJETOS --------------------------- }

     {
      Construtor
     }
     constructor Create; override;

     {
      Destrutor
     }
     destructor Destroy  ;  override;

     procedure Clear; override;

     procedure addCriterio(campo, valor : string; operador: string);

     procedure andCriterio(campo, valor : string; operador: string);

     procedure orCriterio(campo, valor : string; operador: string);

     function buildCriterio : string;

     { -------------------------- GERAL -------------------------------------- }

 end;

implementation

uses
 sysutils;

// -------------------------------------------------------------------------- //
// ------------------------ MANUTEN��O OBJETOS ------------------------------ //
// -------------------------------------------------------------------------- //

Constructor TCriterio.Create;

begin
  inherited Create;
end;

Destructor TCriterio.Destroy;

begin
  inherited;
end;

procedure TCriterio.Clear;

begin
  inherited;
end;

procedure TCriterio.addCriterio(campo, valor : string; operador: string);

var i : integer;

begin

  i:= Length(criterio);

  // Adiciono uma posi��o na estrutura
  SetLength(criterio, i+1);

  // Monto o crit�rio
  criterio[i].nomeCampo   := campo;
  criterio[i].parametro   := 'p'+campo;
  criterio[i].valorCampo  := valor;
  criterio[i].operador    := operador;
  criterio[i].condicional := '';
end;

procedure TCriterio.andCriterio(campo, valor : string; operador: string);
begin

  // Adiciono uma posi��o na estrutura
  SetLength(criterio,Length(criterio)+1);

  // Monto o crit�rio
  criterio[Length(criterio)].nomeCampo   := campo;
  criterio[Length(criterio)].parametro   := 'p'+campo;
  criterio[Length(criterio)].valorCampo  := valor;
  criterio[Length(criterio)].operador    := operador;
  criterio[Length(criterio)].condicional := 'AND';
end;

procedure TCriterio.orCriterio(campo, valor : string; operador: string);
begin

  // Adiciono uma posi��o na estrutura
  SetLength(criterio,Length(criterio)+1);

  // Monto o crit�rio
  criterio[Length(criterio)].nomeCampo   := campo;
  criterio[Length(criterio)].parametro   := 'p'+campo;
  criterio[Length(criterio)].valorCampo  := valor;
  criterio[Length(criterio)].operador    := operador;
  criterio[Length(criterio)].condicional := 'OR';
end;

function TCriterio.buildCriterio : string;

var i : integer;

begin

  // Iniializo a vari'avel
  Result := '';

  for i := 0 to Length(criterio) -1 do
  begin
    if (criterio[i].operador <> EmptyStr) then
    begin

      // Monto o crit�rio
      Result := Result+''+ criterio[i].nomeCampo+' '+criterio[i].operador+' '+':'+
                criterio[i].parametro;
    end;
  end;
end;

end.

