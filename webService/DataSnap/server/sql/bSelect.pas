{ ------------------------- INFORMA��ES GERAIS ---------------------------------
  bSelect (Representa uma consulta SQL - SELECT)
  Data in�cio: 13/06/2016

  Vandeir Roberto Mar�al
  AJI - Sistemas
 ----------------------------------------------------------------------------- }
unit bSelect;

interface

 uses Classes,DB,  bCriterioSql;

 type TSelect = class (TCriterio)
   private
     { --------------------------- ATRIBUTOS --------------------------------- }

     { -- ESTRUTURA --
     Refer�ncia ao ClientDataSet associado a esta consulta
     }
     cds : TDataSet;

     { -- ESTRUTURA --
     Cont�m as cl�usulas de OrderBy
     }
     orderby : TStringList;

     { -- ESTRUTURA --
     Cont�m as cl�usulas de GroupBy
     }
     groupby : TStringList;

     { -- DADO --
     DISTINCT, indica se existe a restri��o
     }
     distinct : boolean;

     { -- DADO --
     Cont�m a cl�usula Limit
     }
     limit : string;

     {
      Monta o campo, que pode ser um nome ou um SQL

      Parameters:
          i - posi��o do campo

      Return:
          o campo montado
     }
     function montaColuna(i : integer) : string;

   protected

   public
     { -----------------------  MANUTEN��O OBJETOS --------------------------- }

     {
      Cria um novo objeto da classe TSelect
     }
     constructor Create; overload; override;


     destructor Destroy  ;  override;

     procedure Clear; override;

     { --------------------------- ADD --------------------------------------- }

     {
      Adiciona um DISTINCT
     }
     procedure addDistinct;

     procedure addColuna (nome : string);

     {
      Adiciona um novo campo a ser selecionado na consulta

      Parameters:
          nome - nome do campo a ser adicionado
          alias - apelido para a tabela do campo
     }
     procedure addSelect (nome : string); overload;

     {
      Adiciona uma nova tabela

      Parameters:
          nome - nome da tabela a ser adicionada
          alias - apelido para a tabela
     }
     procedure addTable (nome,alias : string) ; overload ;

     {
      Adiciona uma cl�usula OrderBy a consulta SQL

      Parameters:
          s - a cl�usula com os campos tem que estar separados por v�rgula
     }
     procedure addOrderBY (s : string) ;

     {
      Adiciona uma cl�usula GroupBy a consulta SQL

      Parameters:
          s - a cl�usula com os campos tem que estar separados por v�rgula
     }
     procedure addGroupBY (s : string) ;

     {
      Adiciona uma cl�usula Limit a consulta SQL

      Parameters:
          s - a cl�usula com os campos tem que estar separados por v�rgula
          Ex. 0,1000
     }
     procedure addLimit (s : string) ; overload;


     { -------------------------- GERAL -------------------------------------- }

     {
      Constr�i uma consulta SQL

      Return:
          a consulta SQL
     }
     function buildSQL  : string;  override;

     {
      Executa a consulta utilizando a conex�o geral (conn.execSQL).

      Parameters:
          cds - o ClientDataSet

      Return:
          o n�mero de registros afetados
     }
     function Execute (var cds : TDataSet) : integer; reintroduce; overload;
 end;

implementation

uses
 sysutils;

// -------------------------------------------------------------------------- //
// ------------------------ MANUTEN��O OBJETOS ------------------------------ //
// -------------------------------------------------------------------------- //

Constructor TSelect.Create;

begin
  inherited Create;

  // Constr�i as listas
  coluna      := TStringList.Create;
  orderby     := TStringList.Create;
  groupby     := TStringList.Create;

  // Inicia;
  Clear;
end;

Destructor TSelect.Destroy;

begin

  // Listas
  coluna.Free;
  orderby.Free;
  groupby.Free;

  inherited;
end;

procedure TSelect.Clear;

begin

  inherited;

  // ClientDataSet
  self.cds := nil;

  coluna.Clear;
  tabelas.Clear;
end;

// -------------------------------------------------------------------------- //
// --------------------------------- ADD ------------------------------------ //
// -------------------------------------------------------------------------- //

procedure TSelect.addDistinct;

begin
  distinct := true;
end;

procedure TSelect.addColuna (nome : string);
begin
  coluna.Add(nome);
end;

procedure TSelect.addSelect(nome : string);

var i : integer;
    nome2, alias : string;

begin

  // campo com mesmo nome
  if (coluna.IndexOf(nome) <> -1) then begin

    // n�o adiciona
    exit;
  end;

  // alias com mesmo nome AS
  for i:=0 to coluna.Count -1 do begin

    // alias nome
    if (Pos('AS ',UpperCase(nome)) <> 0) then begin

      nome2 := Copy(nome,Pos('AS ',UpperCase(nome))+3,Length(nome));
    end else begin

      nome2 := nome;
    end;

    // alias campo
    if (Pos('AS ',UpperCase(coluna[i])) <> 0) then begin

      alias := Copy(coluna[i],Pos('AS ',UpperCase(coluna[i]))+3,Length(coluna[i]));
    end else begin

      alias := coluna[i];
    end;

    // compara
    if (nome2 = alias) then begin

      // n�o adiciona
      exit;
    end;
  end;

  // Adiciona normal
  coluna.Add(nome);
end;

procedure TSelect.addTable(nome,alias : string);

begin
  tabelas.Add(nome+' '+alias);
end;


procedure TSelect.addOrderBY(s : string);

begin
  orderby.Add(s);
end;

procedure TSelect.addGroupBY(s : string);

begin
  groupby.Add(s);
end;

procedure TSelect.addLimit(s : string);

begin
  limit := s;
end;

function TSelect.buildSQL : string;

var i : integer;
    sql : string;
    order_u : string;

begin

  // Herda
  Result := inherited buildSQL;

  // SELECT
  sql := 'SELECT ';

  // DISTINCT
  if (distinct) then begin
    sql := sql + 'DISTINCT ';
  end;

  // CAMPOS
  for i:=0 to coluna.Count-2 do begin

    sql := sql + montaColuna(i) + ',';
  end;

  // �ltimo campo
  sql := sql + montaColuna(coluna.Count-1);

  // FROM
  sql := sql + ' FROM ';

  // TABELAS
  for i:=0 to tabelas.Count-2 do begin

    sql := sql + montaTabela(i) + ',';
  end;

  // �ltimo campo
  sql := sql + montaTabela(tabelas.Count-1);

  sql := sql + ' WHERE ' + buildCriterio;

  // Guarda para pr�ximo BUILD
  Result := sql;
end;

function TSelect.Execute (var cds : TDataSet) : integer;

var sql : string;

begin

  cds := Execute(buildSQL);
end;

function TSelect.montaColuna(i : integer) : string;

var sql : string;

begin

  sql := coluna.Strings[i];

  // Retorno
  Result := sql;
end;

end.
