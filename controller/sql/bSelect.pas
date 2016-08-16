{ ------------------------- INFORMAÇÕES GERAIS ---------------------------------
  bSelect (Representa uma consulta SQL - SELECT)
  Data início: 13/06/2016

  Vandeir Roberto Marçal
  AJI - Sistemas
 ----------------------------------------------------------------------------- }
unit bSelect;

interface

 uses DBClient, Classes, bCriterioSql,IBX.IBQuery,IBX.IBDataBase,pDataModule;

 type TSelect = class (TCriterio)
   private
     { --------------------------- ATRIBUTOS --------------------------------- }

     { -- ESTRUTURA --
     Referência ao ClientDataSet associado a esta consulta
     }
     cds : TClientDataSet;

   protected

   public
     { -----------------------  MANUTENÇÃO OBJETOS --------------------------- }

     {
      Cria um novo objeto da classe TSelect
     }
     constructor Create; overload; override;


     destructor Destroy  ;  override;

     procedure Clear; override;

     { -------------------------- GERAL -------------------------------------- }

     {
      Constrói uma consulta SQL

      Return:
          a consulta SQL
     }
     function buildSQL  : string;  override;

     {
      Executa a consulta utilizando a conexão geral (conn.execSQL).

      Parameters:
          cds - o ClientDataSet

      Return:
          o número de registros afetados
     }
     function Execute (var cds : TClientDataSet) : integer;overload;
 end;

implementation

uses
 sysutils;

// -------------------------------------------------------------------------- //
// ------------------------ MANUTENÇÃO OBJETOS ------------------------------ //
// -------------------------------------------------------------------------- //

Constructor TSelect.Create;

begin
  inherited Create;
end;

Destructor TSelect.Destroy;

begin
  inherited;
end;

procedure TSelect.Clear;

begin

  inherited;
  self.cds := nil;
end;

function TSelect.buildSQL : string;

var i : integer;
    sql : string;
    order_u : string;

begin

  // Herda
  Result := '';

  // SELECT
  sql := 'SELECT ';

  // CAMPOS
  for i:=0 to Length(campo)-2 do
  begin

    sql := sql + montaColuna(i) + ',';
  end;

  // Último campo
  sql := sql + montaColuna(Length(campo)-1);

  // FROM
  sql := sql + ' FROM ';

  // TABELAS
  for i:=0 to tabelas.Count-2 do begin

    sql := sql + montaTabela(i) + ',';
  end;

  // Último campo
  sql := sql + montaTabela(tabelas.Count-1);

  // Verifico se exist critério
  if (Length(criterio) > 0) then
  begin
    sql := sql + ' WHERE ' + buildCriterio;
  end;

  // Guarda para próximo BUILD
  Result := sql;
end;

function TSelect.Execute (var cds : TClientDataSet) : integer;

Var
  ConsultaCDS : TClientDataSet;
  iCont, i    : Integer;

begin

  try
    try
      with script do
      begin

        Database := UdmParame.ciGtrans;

        SQL.Clear;
        SQL.Add(buildSQL);

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

        if (script.Active) then
        begin
          script.Close;
        end;
        FreeAndNil(script);

        Abort;
      End;
    end;

    ConsultaCDS := TClientDataSet.Create(nil);
    with script do
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

    ConsultaCDS.Open;
    ConsultaCDS.First;
    cds := ConsultaCDS;
  except on E: Exception do
    Begin

      if ConsultaCDS <> Nil then
      Begin
        ConsultaCDS.Close;
        FreeAndNil(ConsultaCDS);
      End;
      Abort;
    End;
  end;
end;


end.
