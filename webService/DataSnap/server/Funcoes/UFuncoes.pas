unit UFuncoes;

interface

uses SysUtils, IBX.IBCustomDataSet, IBX.IBQuery, Forms, Buttons, IBX.IBDatabase,  DB, ComObj,
     Windows, DBClient,Printers, DBGrids, {DBXpress,} SqlExpr,
     Variants, Classes, Graphics, Controls, StdCtrls, Mask, shellapi,
     TLHelp32, ExtCtrls, ShlObj, ActiveX, Registry, {JvComputerInfoEx,} Math, pDataModule;
type
  tTipoPapel = (tTipoPapel_A4, tTipoPapel_Carta, tTipoPapel_Oficio);

  TEventHandlers = class
    procedure Change(Sender: TObject);
    procedure KeyPress(Sender: TObject; var Key: Char);
    procedure KeyPress2(Sender: TObject; var Key: Char);
    procedure DblClick(Sender : TObject);
    procedure DblClickExpandir(Sender : TObject);
    procedure onClick(Sender : TObject);
  end;

  type TRecInfUsuarioWindows = Record
    UsuarioLogado  : String;
    GrupoTrabalho  : String;
    NomeComputador : String;
    Dominio        : String;
    UsuarioDominio : String;
    EnderecoIP     : String;
  End;

function AscCar(fTexto: string): string;

//function RetornarConsulta(psSQL : String): TIBQuery;
function RetornarConsulta(psSQL : String; pcptConexao : TIBDatabase = nil): TIBQuery;
function RetornarConsultaCDS(psSQL : String; pcptConexao : TIBDatabase = nil; bMostrarMsg : Boolean = True): TClientDataSet;
function getDataHoraFB(pcTipo : char) : TDateTime;

// Adicionado por Guilherme Oliveira em 30/05/2012 as 10:54
procedure FecharDestruirDataSet(out pcptConsulta : TIBQuery);
procedure FecharDestruirTransacao(pTransacao : TIBTransaction);
function ExecutarSQL(psSQL : String ; pcConexao : TIBDatabase ;
                     pcTransacao : TIBTransaction = Nil; bMsg : Boolean = True; slParametros : TStringList = Nil) : Boolean;
procedure FecharQueryDBExpress(out pQueryDBExpress : TSQLQuery);



procedure FecharClienteDataSet(fNomeForm: TForm);
procedure FecharQuery(fNomeForm: TForm);
// CLIENTE:  solicitado por Multiportos
// OBJETIVO: Função para Printar o formulario
// VERSÃO:
// DESENVOLVEDOR: LUCIANO LOPES em 30/10/2013 às 11:42hs
procedure DefinirTamanhoPapel(Width, Height : LongInt);
procedure ImprimirFormulario(frm: TForm; TipoPapel: tTipoPapel);
procedure FecharDestruirForm(pcptForm : TForm);

{
  Converte um valor para dinheiro (duas casas decimais)
}
function toMoney (const valor : double) : string; overload;

{
 Converte Float
}
function arredondar(const AValue: Double; const ADigit: TRoundToRange): Double;


// RETIRANDO CÓDIGO DO ACBR E COPIANDO PARA CÁ...
// NAO COLOQUEI A USES DO ACBER... SENÃO IRÁ VINCULAR NO PROJETO.
function ValidarChave(const chave: string): boolean;
function SomenteNumeros(const s: string): string;
function GerarDigito(var Digito: integer; chave: string): boolean;
function ValidarCodigoUF(const Codigo: integer): boolean;
function ValidarAAMM(const AAMM: string): boolean;
function ValidarNumeros(const s: string): boolean;
function ValidarCNPJ(const numero: string): boolean;
procedure IndexaGrid(Column: TColumn; bAdicionarIndice : Boolean = False);
Function CDSAbertoComDados(cds : TClientDataSet; bOrdenar : Boolean = False) : Boolean;
Function ClonarCDS(cdsOriginal : TClientDataSet; bComDados : Boolean; bNuncaRequerir: Boolean = False) :  TClientDataSet;
function GetAveCharSize(Canvas: TCanvas): TPoint;
function InputQueryQtdeCaracteres(const sNomeJanela, sDescritivo: string;
  var Value: string; iMaxLength: Integer = 0; bEnterOk: Boolean = False): Boolean;
function InputQueryPersonalizado(const ACaption, APrompt: string; var Value: String;
  sTipo: Char; out bOcorreuErroValidacao: Boolean; bPassword : Boolean = False): Boolean;
Function RetornaLiberacao (sUsuario, sModulo, sRotina : String): Boolean;
function FecharProcesso(ExeFileName: string): Integer;
{ Verifica se dDataInicial + iDias cai num sabado, domingo ou feriado(cadastro no tms) e retorna o próximo dia util. }
function FormularioGrid(const sNomeJanela, sDescritivo: string;
  var cds : TClientDataSet; bExpandirDoisCliques : Boolean = False): Boolean;

function GetEnvVarValue(const VarName: string): string;
procedure CriarAtalho(sCaminhoOrigem, sCaminhoDestino, sDecricaoAtalho, Argumentos : String);
Function ArredondaPorDecimal(valor:Real;casasDecimais:integer):Real;
Procedure ResetAggregates(cds : TClientDataSet);
Procedure AtualizarRateio(cdsRateio : TClientDataSet; sOpe, sCodigoLancamentoPrincipal, sCodigoLancamento : String; dValorDocumentoPrincipal, dValorNovoDocumento : Double);


Var
  TransacaoLocal : TIBTransaction;
  EvHandler:TEventHandlers;

implementation

uses  StrUtils, DateUtils;

procedure TEventHandlers.Change(Sender: TObject);
Begin
  TLabel(TForm(TEdit(Sender).GetParentComponent).FindComponent('lblQtdeCaracteres')).Caption :=
                                      'Caracteres: '+IntToStr(Length(Trim(TEdit(Sender).Text)));
  TLabel(TForm(TEdit(Sender).GetParentComponent).FindComponent('lblQtdeCaracteres')).Update;
end;

procedure TEventHandlers.KeyPress(Sender: TObject; var Key: Char);
Begin
  if key = #27 then
  Begin
    TButton(TForm(TEdit(Sender).GetParentComponent).FindComponent('btnCancelar')).Click;
  End;
end;

procedure TEventHandlers.KeyPress2(Sender: TObject; var Key: Char);
Begin
  if key = #27 then
  Begin
    TButton(TForm(TEdit(Sender).GetParentComponent).FindComponent('btnCancelar')).Click;
  End;
  if Key = #13 then
  Begin
    TButton(TForm(TEdit(Sender).GetParentComponent).FindComponent('btnAdicionar')).Click;
  End;
end;

procedure TEventHandlers.DblClick(Sender : TObject);
Begin
  TForm(TDBGrid(Sender).Parent).ModalResult := mrOK;
End;

procedure TEventHandlers.DblClickExpandir(Sender : TObject);
Begin
  if TMemo(TForm(TDBGrid(Sender).GetParentComponent).FindComponent('memo')) <> Nil then
  Begin
    TMemo(TForm(TDBGrid(Sender).GetParentComponent).FindComponent('memo')).Lines.Text :=
      TDBGrid(Sender).DataSource.DataSet.Fields[0].AsString;
  End;
  TDBGrid(Sender).SendToBack;
End;


procedure TEventHandlers.onClick(Sender : TObject);
Begin
  TMemo(Sender).SendToBack;
End;

function BloquearCaracter(pcBloquear : Char ; pcDigitado : Char) : Char;
begin
  if (pcDigitado = pcBloquear) then
  begin
    Result := #0;
  end
  else
  begin
    Result := pcDigitado;
  end;
end;


function getSQL(iTabela : Smallint) : string;
Var
  sSQL : string;
begin
  case iTabela of
    1 : begin
          sSQL := 'SELECT GEN_ID(GEN_CLASS_SUBCONTA_ID, 1) FROM RDB$DATABASE';
        end;
    2 : begin
          sSQL := 'SELECT GEN_ID(GEN_TRCHEQUE_ID, 1) FROM RDB$DATABASE';
        end;
  end;
  Result := sSQL;
end;




function CriarTransacao(pobjConexao : TIBDatabase) : TIBTransaction;
Var
  objTransacao : TIBTransaction;
begin
  try
    objTransacao := TIBTransaction.Create(Nil);
    with objTransacao do
    begin
      DefaultDatabase := pobjConexao;
      DefaultAction := TARollback;
      Params.Add('read_committed');
      Params.Add('rec_version');
      Params.Add('wait');
      StartTransaction;
    end;
    Result := objTransacao;
    //FreeAndNil(objTransacao);
    Application.ProcessMessages;
  except
    if (objTransacao <> Nil) then
    begin
      if (objTransacao.InTransaction) then
      begin
        objTransacao.Rollback;
      end;
      FreeAndNil(objTransacao);
    end;
    //show('Não foi possível iniciar a transação.');
    Application.ProcessMessages;
  end;
end;


function toCPF (const valor : string) : string;

begin

  // CPF   xxx.xxx.xxx-xx
  // CNPJ  xxx.xxx.xxx/xxxx-xx
  Result := trim(valor);

  // Verifico o tamanho para
  if (Length(trim(valor)) > 11) then begin

    // Ajusta valores xx.xxx.xxx/xxxx-xx
    Insert('-',Result,Length(trim(valor)) -1);
	  Insert('/',Result,Length(trim(valor)) - 5);
    Insert('.',Result,Length(trim(valor)) - 8);

    if (Length(valor) > 12) then begin
      Insert('.',Result,Length(trim(valor)) - 11);
    end;

    //verifico se tenho

  end else begin

    // Ajusta valores xxx.xxx.xxx
    Insert('.',Result,4);
    Insert('.',Result,8);
	  Insert('-',Result,12);
  end;
end;

function toCEP(const valor : string) : string;

begin
	// CEP xxxxx-xxx
  Result := valor;

  // Se o numeração possuir mais que 5 dígitos  e já não tiver hifen
  if (Length(valor) > 5) and (Pos('-',Result) = 0) then begin

    // Insere dígito na numeração
  	Insert('-',Result,6);
  end;
end;



//function RetornarConsulta(psSQL : String): TIBQuery;
//Var
//  Consulta : TIBQuery;
//begin
//  try
//    Consulta := TIBQuery.Create(Nil);
//    with Consulta do
//    begin
//      Database := dmParame.ciFinanc;
//      Close;
//      Prepared := False;
//      SQL.Clear;
//      SQL.Add(Trim(psSQL));
//      Prepared := True;
//      Open;
//      //CLIENTE: TODOS solicitado por JORGE SANTOS - AJI SISTEMAS
//      //OBJETIVO: AJUSTAR FUNÇÃO PARA PERMITIR RETORNOS CORRETOS DOS RECURSOS DO DATASET IBQUERY (RECORDCOUNT POR EXEMPLO)
//      //VERSÃO: 2012.v02
//      //DESENVOLVEDOR: JORGE SANTOS em 11/05/2012 às 10:00hs
//      Last;
//      First;
//      // FIM AJUSTE
//    end;
//    Result := Consulta;
//  except
//    if (Consulta <> Nil) then
//    begin
//      FreeAndNil(Consulta);
//    end;
//    MsgErro('Não foi possível efetuar a consulta.');
//    Application.ProcessMessages;
//    Abort;
//  end;
//end;

function AscCar(ftexto: string):string;
var
  xindice: byte;
  xstring, xretorn: string;
begin
  // Desembaralha o código ASC
  xindice := 1; xstring := '';
  while xindice <= Length(fTexto) do
  begin
    xstring := xstring + copy(ftexto, xindice + 1, 1) + copy(ftexto, xindice, 1);
    xindice := xindice + 2;
  end;
  xstring := TrimRight(xstring);

  xindice := 1;
  while xindice <= length(xstring) do
  begin
    xretorn := xretorn + chr(StrToInt(copy(xstring, xindice, 3)) + 36);
    xindice := xindice + 3;
  end;
  AscCar := xretorn;
end;

function RetornarConsulta(psSQL : String; pcptConexao : TIBDatabase = nil): TIBQuery;
Var
  Consulta : TIBQuery;
begin
  try
    Consulta := TIBQuery.Create(Nil);
    with Consulta do
    begin
      if (pcptConexao = nil) then
      begin
        Database := UdmParame.ciGtrans;
      end
      else
      begin
        Database := pcptConexao;
      end;

      SQL.Clear;

      SQL.Add('SELECT COUNT(*)from trusuari WHERE logusuari = :pNome');
      ParamByName('pNome').AsString := 'VANDEIR';
//      SQL.Add('SELECT senusuari AS SENHA FROM trusuari WHERE logusuari = :pNome');
//      ParamByName('pNome').AsString := 'VANDEIR';
      Open;
    end;
    Result := Consulta;
  except on E: Exception do
    Begin
      FecharDestruirDataSet(Consulta);
      Application.ProcessMessages;
      Abort;
    End;
  end;
end;

function RetornarConsultaCDS(psSQL : String; pcptConexao : TIBDatabase = nil; bMostrarMsg : Boolean = True): TClientDataSet;
Var
  Consulta : TIBQuery;
  ConsultaCDS : TClientDataSet;
  iCont : Integer;
Begin
  Try
    Consulta := RetornarConsulta(psSQL, pcptConexao);
    ConsultaCDS := TClientDataSet.Create(Application);
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
      if bMostrarMsg then
      Begin
      End;
      Application.ProcessMessages;
      Abort;
    End;
  end;
End;

function getDataHoraFB(pcTipo : char) : TDateTime;
Var
  Script : TIBQuery;
begin
  try
    Script := TIBQuery.Create(Nil);

    with Script do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT CURRENT_DATE, CURRENT_TIME, CURRENT_TIMESTAMP ');
      SQL.Add('FROM RDB$DATABASE');
      Open;
      case pcTipo of
        'D' : Result := Fields[0].AsDateTime;
        'H' : Result := Fields[1].AsDateTime;
        'A' : Result := Fields[2].AsDateTime;
      end;
      Close;
    end;
    FreeAndNil(Script);
  except
    if Script <> nil then
    begin
      FreeAndNil(Script);
    end;
    Abort;
  end;
end;

procedure FecharDestruirDataSet(out pcptConsulta : TIBQuery);
begin
  if (pcptConsulta <> Nil) then
  begin
    if (pcptConsulta.Active) then
    begin
      pcptConsulta.Close;
    end;
    FreeAndNil(pcptConsulta);
  end;
end;

procedure FecharDestruirTransacao(pTransacao : TIBTransaction);
begin
  if (pTransacao <> Nil) then
  begin
    if (pTransacao.InTransaction) then
    begin
      pTransacao.Rollback;
    end;
    FreeAndNil(pTransacao);
  end;
end;

function ExecutarSQL(psSQL : String ; pcConexao : TIBDatabase ;
                     pcTransacao : TIBTransaction = Nil; bMsg : Boolean = True; slParametros : TStringList = Nil) : Boolean;
Var
  Script : TIBQuery;
  iCont  : Integer;
  objTransacao : TIBTransaction;
begin
  Try
    Try
      objTransacao := TIBTransaction.Create(Application);
      Script := TIBQuery.Create(Application);

      Result := False;

      with Script do
      begin
        Database    := pcConexao;

        if (pcTransacao <> Nil) then
        begin
          Transaction    := pcTransacao;
        end
        else
        begin
          objTransacao := CriarTransacao(pcConexao);
          Transaction    := objTransacao;
        end;

        Close;
        Prepared := False;
        SQL.Clear;
        SQL.Add(psSQL);
        if slParametros <> Nil then
        Begin
          For iCont := 0 to slParametros.Count-1 do
          Begin
            Params[iCont].AsString := slParametros[iCont];
          End;
        End;
        Prepared := True;
        ExecSQL;
      end;

      if (objTransacao <> Nil) then
      begin
        if (objTransacao.InTransaction) then
        begin
          objTransacao.Commit;
        end;
      end;
      Result := True;
    except on E:Exception do
      Begin
        if bMsg then
        begin
        end;
        Application.ProcessMessages;
        Abort;
      end;
    End;
  Finally
    FecharDestruirTransacao(objTransacao);
    FecharDestruirDataSet(Script);
  End;
End;

Function RetornaCampoBanco (psSQL : String; dbConexao : TIBDatabase = Nil) : Variant;
Var
  Consulta : TIBQuery;
begin
  try
    Consulta := TIBQuery.Create(Nil);
    with Consulta do
    begin
      if dbConexao <> Nil then
      Begin
        DataBase := dbConexao;
      End
      Else
      Begin
      End;
      Close;
      Prepared := False;
      SQL.Clear;
      SQL.Add(Trim(psSQL));
      Prepared := True;
      Open;
      Last;
      First;
    end;
    Result := Consulta.Fields[0].Value;
    FecharDestruirDataSet(Consulta);
  except
    FecharDestruirDataSet(Consulta);
    Application.ProcessMessages;
    Abort;
  end;
end;

function ExisteExcelInstalado : Boolean;
Var
  Excel : OleVariant;
begin
  Result := False;
  try
    Try
      Excel := CreateOleObject('Excel.Application');
      Excel.Workbooks.Add;
      Result := True;
//      VarClear(Excel);
    Except
//      VarClear(Excel);
      Result := False;
    end;
  finally
    Excel.Quit;
  end;
end;

function RemoverCaracterEspecial(texto : String; RemoveSomenteAcentos : Boolean = False) : String;
begin
  //CLIENTE: TODOS solicitado por JORGE SANTOS - AJI SISTEMAS
  //OBJETIVO: NORMALIZAR FUNÇÃO PARA RETORNAR UM CARACTER VAZIO AO INVÉS DE UNDERLINE
  //         (CONDIÇÕES QUE NÃO ENVOLVIAM LETRAS, SOMENTE SÍMBOLOS)
  //VERSÃO: 2012.v03
  //DESENVOLVEDOR: JORGE SANTOS em 17/02/2012 às 16:17hs
  if (texto <> '') then Texto := StringReplace(Texto, 'ç', 'c', [rfreplaceall]);
  if (texto <> '') then Texto := StringReplace(Texto, 'à', 'a', [rfreplaceall]);
  if (texto <> '') then Texto := StringReplace(Texto, 'á', 'a', [rfreplaceall]);
  if (texto <> '') then Texto := StringReplace(Texto, 'ó', 'o', [rfreplaceall]);
  if (texto <> '') then Texto := StringReplace(Texto, 'ã', 'a', [rfreplaceall]);
  if (texto <> '') then Texto := StringReplace(Texto, 'ê', 'e', [rfreplaceall]);  
  if (texto <> '') then Texto := StringReplace(Texto, 'é', 'e', [rfreplaceall]);
  if (texto <> '') then Texto := StringReplace(Texto, 'è', 'e', [rfreplaceall]);
  if (texto <> '') then Texto := StringReplace(Texto, 'ô', 'o', [rfreplaceall]);
  if (texto <> '') then Texto := StringReplace(Texto, 'ú', 'u', [rfreplaceall]);
  if (texto <> '') then Texto := StringReplace(Texto, 'ü', 'u', [rfreplaceall]);
  if (texto <> '') then Texto := StringReplace(Texto, 'í', 'i', [rfreplaceall]);
  // Maiusculas
  if (texto <> '') then Texto := StringReplace(Texto, 'Ç', 'C', [rfreplaceall]);
  if (texto <> '') then Texto := StringReplace(Texto, 'À', 'A', [rfreplaceall]);
  if (texto <> '') then Texto := StringReplace(Texto, 'Á', 'A', [rfreplaceall]);
  if (texto <> '') then Texto := StringReplace(Texto, 'Ó', 'O', [rfreplaceall]);
  if (texto <> '') then Texto := StringReplace(Texto, 'Ã', 'A', [rfreplaceall]);
  if (texto <> '') then Texto := StringReplace(Texto, 'Ê', 'E', [rfreplaceall]);
  if (texto <> '') then Texto := StringReplace(Texto, 'É', 'E', [rfreplaceall]);
  if (texto <> '') then Texto := StringReplace(Texto, 'È', 'E', [rfreplaceall]);
  if (texto <> '') then Texto := StringReplace(Texto, 'Ô', 'O', [rfreplaceall]);
  if (texto <> '') then Texto := StringReplace(Texto, 'Ú', 'U', [rfreplaceall]);
  if (texto <> '') then Texto := StringReplace(Texto, 'Ü', 'U', [rfreplaceall]);
  if (texto <> '') then Texto := StringReplace(Texto, 'Í', 'I', [rfreplaceall]);
  // Caracteres
  if not RemoveSomenteAcentos then
  Begin
    if (texto <> '') then Texto := StringReplace(Texto, '§', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '$', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '@', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '£', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '&', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '#', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '1ª', '1', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '1º', '1', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '.', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, ',', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '/', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '\', ' ', [rfreplaceall]);

    if (texto <> '') then Texto := StringReplace(Texto, '-', ' ', [rfreplaceall]);

    if (texto <> '') then Texto := StringReplace(Texto, '_', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, ':', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '(', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, ')', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '%', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '>', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '<', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '!', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '¨', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '*', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '^', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '~', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '´', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '`', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '"', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '¬', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '+', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, ';', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '?', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '°', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, 'ª', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '{', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '}', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '[', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, ']', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '=', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '''', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '!', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '¨', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '*', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '^', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '~', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '´', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '`', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '"', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '¬', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '+', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, ';', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '?', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '°', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, 'ª', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '{', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '}', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '[', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, ']', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '=', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '''', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '²', ' ', [rfreplaceall]);
    if (texto <> '') then Texto := StringReplace(Texto, '³', ' ', [rfreplaceall]);
  End;
  Result := Texto;
end; 

function VerificaTeclaPressionada(const Key: integer): boolean;
begin
  Result := GetKeyState(Key) and 128 > 0;
end;

function MesExtenso (Data : TDateTime):String;
var
  Meses : array[ 1..12 ] of String;
  Dia, Mes, Ano : Word;
begin
{ Meses }
  Meses[1] := 'Janeiro';
  Meses[2] := 'Fevereiro';
  Meses[3] := 'Março';
  Meses[4] := 'Abril';
  Meses[5] := 'Maio';
  Meses[6] := 'Junho';
  Meses[7] := 'Julho';
  Meses[8] := 'Agosto';
  Meses[9] := 'Setembro';
  Meses[10]:= 'Outubro';
  Meses[11]:= 'Novembro';
  Meses[12]:= 'Dezembro';
  { deixa a data em pedaços : dividida ano, mes e dia }
  DecodeDate(Data, Ano, Mes, Dia);
  Result := Meses[Mes];
end;

function FormatDataBD(Data : TDate) : String;

var ano, mes , dia : Word;

begin

  // Pego os campos da data separados
  DecodeDate(data,ano, mes, dia);

  // Data Formatada
  Result := QuotedStr(IntToStr(dia)+'.'+IntToStr(mes)+'.'+IntToStr(ano));
end;

procedure FecharQueryDBExpress(out pQueryDBExpress : TSQLQuery);
begin
  if (pQueryDBExpress.Active) then
  begin
    pQueryDBExpress.SQL.Clear;
    pQueryDBExpress.Close;
  end;
end;

procedure FecharClienteDataSet(fNomeForm: TForm);
var
  i: Integer;
begin
  for i:= 0 to fNomeForm.ComponentCount -1 do
  begin
    if (fNomeForm.Components[i].ClassType = TClientDataSet) then
    begin
      if TClientDataSet(fNomeForm.Components[i]).Active then
      begin
        TClientDataSet(fNomeForm.Components[i]).Close;
      end;
    end;
  end;  
end;

procedure FecharQuery(fNomeForm: TForm);
var
  i: Integer;
begin
  for i:= 0 to fNomeForm.ComponentCount -1 do
  begin
    if (fNomeForm.Components[i].ClassType = TIBQuery) then
    begin
      if TIBQuery(fNomeForm.Components[i]).Active then
      begin
        TIBQuery(fNomeForm.Components[i]).Close;
      end;
    end;
  end;
end;

// CLIENTE:  solicitado por Multiportos
// OBJETIVO: Função para Printar o formulario
// VERSÃO:
// DESENVOLVEDOR: LUCIANO LOPES em 30/10/2013 às 11:42hs

procedure DefinirTamanhoPapel(Width, Height : LongInt);
var
  Device, Driver, Port : array[0..255] of char;
  hDMode : THandle;
  pDMode : PDEVMODE;
begin
  Printer.GetPrinter(Device, Driver, Port, hDMode);
  If hDMode <> 0 then
  begin
  pDMode := GlobalLock( hDMode );
  If pDMode <> nil then
  begin
  pDMode^.dmPaperSize := DMPAPER_USER;
  pDMode^.dmPaperWidth := Width;
  pDMode^.dmPaperLength := Height;
  pDMode^.dmFields := pDMode^.dmFields or DM_PAPERSIZE;
  GlobalUnlock( hDMode );
  end;
  end;
end;


procedure ImprimirFormulario(frm: TForm; TipoPapel: tTipoPapel);
var
  bmp: TBitMap;
  x, y, z, WDPI, HDPI,PaginaLargura,PaginaAltura: Integer;
  OldColor: TColor;

begin
  Screen.Cursor := crHourGlass;
  OldColor := frm.Color;
  frm.Color := clWhite;
  frm.Update;
  bmp := frm.GetFormImage;
  with Printer do
  begin
  Orientation := poLandscape;
    if (TipoPapel = tTipoPapel_A4) then
    begin
      PaginaLargura := 210;
      PaginaAltura  := 297;
    end;

    if (TipoPapel = tTipoPapel_Carta) then
    begin
      PaginaLargura := 216;
      PaginaAltura  := 279;
    end;

    if (TipoPapel = tTipoPapel_Oficio) then
    begin
      PaginaLargura := 216;
      PaginaAltura  := 355;
    end;

    DefinirTamanhoPapel(PaginaLargura,PaginaAltura);
    BeginDoc;
    HDPI := PageHeight div 8;
    WDPI := PageWidth div 8;
    x := PageWidth - Round(WDPI*0.05); {0.4" margem direita}
    y := PageHeight - Round(HDPI*0.05); {0.5" Altura do rodapé}
    Canvas.StretchDraw(Rect(50,50, x, y), bmp);
    EndDoc;
  end;
  bmp.Free;
  frm.Color := OldColor;
  Screen.Cursor := crDefault;
end;

procedure FecharDestruirForm(pcptForm : TForm);
begin
  if (pcptForm <> Nil) then
  begin
    Try
      pcptForm.Close;
    except
    end;

    try
      FreeAndNil(pcptForm);
    except
      on E : Exception do
      begin
      end;
    end;
  end;
end;

function toMoney (const valor : double) : string;

var texto : string;
    i : integer;

begin

  // Arredondo o valor
  texto := FloatToStr (arredondar(valor,-2));

  // Ajusto as casas decimais
  if (Pos(',',texto) = 0) then begin
    texto := texto + '.00';
  end;

  if (Pos(',',texto) + 1 = Length(texto)) then begin
    texto := texto + '0';
  end;

  texto:=StringReplace(texto,',','.',[rfreplaceall]);

  // Retorno o valor formatado
  Result := texto;
end;

function arredondar(const AValue: Double; const ADigit: TRoundToRange): Double;
var
  LFactor: Double;
begin
  Result := RoundTo(AValue,ADigit);
  LFactor := IntPower(10, ADigit);
  Result := (Result / LFactor);
  if (Avalue >= 0) then begin
    Result := Result + 0.5;
  end else begin
    Result := Result - 0.5;
  end;
  Result := Trunc(Result);
  Result := Result * LFactor;
end;


function ValidarChave(const chave: string): boolean;
var
  i: integer;
begin
  result := false;
  if (copy(chave, 1, 3) <> 'NFe') and (copy(chave, 1, 3) <> 'CTe') then
  Begin
    exit;
  End
  Else if Length(chave) <> 47 then
  Begin
    Exit;
  End;
  try
    i := 0;
    if GerarDigito(i, copy(chave, 4, 43)) then
      result := i = StrToInt(chave[length(chave)]);
    if result then
      result := ValidarCodigoUF(StrToInt(copy(somenteNumeros(chave), 1, 2)));
    if result then
      result := ValidarAAMM(copy(somenteNumeros(chave), 3, 4));
    if result then
      result := ValidarCNPJ(copy(somenteNumeros(chave), 7, 14));
  except
    result := false;
  end;
End;

function SomenteNumeros(const s: string): string;
var
  i: integer;
begin
  result := '';
  for i := 1 to length(s) do
    if pos(s[i], '0123456789') > 0 then
      result := result + s[i];
end;


function GerarDigito(var Digito: integer; chave: string): boolean;
var
  i, j: integer;
const
  PESO = '4329876543298765432987654329876543298765432';
begin
  // Manual Integracao Contribuinte v2.02a - Página: 70 //
  chave := somenteNumeros(chave);
  if Trim(Chave) = '' then
  Begin
    Result := False;
  End
  Else
  Begin
    j := 0;
    Digito := 0;
    result := True;
    try
      for i := 1 to 43 do
        j := j + StrToInt(copy(chave, i, 1)) * StrToInt(copy(PESO, i, 1));
      Digito := 11 - (j mod 11);
      if (j mod 11) < 2 then
        Digito := 0;
    except
      result := False;
    end;
    if length(chave) <> 43 then
      result := False;
  End;
end;

function ValidarCodigoUF(const Codigo: integer): boolean;
const
  CODIGOS = '.12.27.16.13.29.23.53.32.52.21.51.50.31.15.25.41.26.22.33.24.43.11.14.42.35.28.17.90.91';
begin
  result := pos('.' + IntToStr(Codigo) + '.', CODIGOS) > 0;
end;

function ValidarAAMM(const AAMM: string): boolean;
begin
  result := (length(AAMM) = 4);
  if not validarNumeros(AAMM) then
    result := false;
  if (result) and (not (StrToInt(copy(AAMM, 3, 2)) in [01..12])) then
    result := false;
end;

function ValidarNumeros(const s: string): boolean;
var
  i: integer;
begin
  result := true;
  for i := 1 to length(s) do
    if pos(s[i], '0123456789') = 0 then
      result := false;
end;

function ValidarCNPJ(const numero: string): boolean;
var
  i, soma, digito1, digito2: SmallInt;
begin
  result := False;
  if length(numero) <> 14 then
    exit;
  soma := 0;
  for i := 1 to 12 do
    soma := soma + StrToInt(Copy(numero, i, 1)) *
      (StrToInt(Copy('5432987654320', i, 1)));
  digito1 := 11 - (soma mod 11);
  if digito1 > 9 then
    digito1 := 0;
  soma := 0;
  for i := 1 to 13 do
    soma := soma + StrToInt(Copy(numero, i, 1)) *
      (StrToInt(Copy('6543298765432', i, 1)));
  digito2 := 11 - (soma mod 11);
  if digito2 > 9 then
    digito2 := 0;
  result := (StrToInt(copy(numero, 13, 2)) = (digito1 * 10 + digito2));
end;

procedure IndexaGrid(Column: TColumn; bAdicionarIndice : Boolean = False);
var
  indice: string;
  existe: boolean;
  sIndex : String;
  clientdataset_idx: tclientdataset;
begin
  if Tobject(Column.Grid.DataSource.DataSet).ClassType = TClientDataSet then
  Begin
    clientdataset_idx := TClientDataset(Column.Grid.DataSource.DataSet);

    if clientdataset_idx.IndexFieldNames = Column.FieldName then
    begin
      clientdataset_idx.IndexFieldNames := '';
      indice := AnsiUpperCase(Column.FieldName+'_INV');

      try
        clientdataset_idx.IndexDefs.Find(indice);
        existe := true;
      except
        existe := false;
      end;

      if not existe then 
        with clientdataset_idx.IndexDefs.AddIndexDef do begin 
          Name := indice; 
          Fields := Column.FieldName;
          Options := [ixDescending];
        end;
      clientdataset_idx.IndexName := indice;
    end
    else
    begin
      if bAdicionarIndice then
      Begin
        if (Pos(Column.FieldName, clientdataset_idx.IndexFieldNames) = 0) then
        Begin
          clientdataset_idx.IndexFieldNames := clientdataset_idx.IndexFieldNames+
                                               ifthen(clientdataset_idx.IndexFieldNames = '','',';')+Column.FieldName;
        End
        Else
        Begin
          sIndex := clientdataset_idx.IndexFieldNames;
          Begin
            StringReplace(sIndex, Column.FieldName, '', [rfReplaceAll]);
          End;
          clientdataset_idx.IndexFieldNames := sIndex;
          // Else
//          if Copy(Pos(Column.FieldName, sIndex)+1,Length(sIndex)) then
//          Begin
//            clientdataset_idx.IndexFieldNames := Copy(sIndex, 1, Pos(Column.FieldName, sIndex)) +
//                                                 Copy(sIndex, Pos(Column.FieldName,sIndex)+Length(Column.FieldName)+1, Length(sIndex))+
//                                                 ';';
//          End;
        End;
      End
      Else
      Begin
        clientdataset_idx.IndexFieldNames := Column.FieldName;
      End;
    end;
  End;
end;

Function CDSAbertoComDados(cds : TClientDataSet; bOrdenar : Boolean = False) : Boolean;
Begin
  Result := False;
  if cds.Active then
  Begin
    if cds.RecordCount > 0 then
    Begin
      Result := True;
      if bOrdenar then
      Begin
        cds.First;
      End;
    End;
  End;
End;

Function ClonarCDS(cdsOriginal : TClientDataSet; bComDados : Boolean; bNuncaRequerir: Boolean = False) :  TClientDataSet;
Var iCont : Integer;
Begin
  Try
    if not cdsOriginal.Active then
    Begin
      Raise Exception.Create('ClientDataSet Original está fechado.');
    End;
    if (Result <> Nil) then
    Begin
      Result.Close;
    End
    Else
    Begin
      Result := TClientDataSet.Create(Application);
    End;
    With Result do
    Begin
      For iCont := 0 to cdsOriginal.Fields.Count-1 do
      Begin
        if bNuncaRequerir then
        begin
          FieldDefs.Add(cdsOriginal.Fields[iCont].FieldName,
                        cdsOriginal.Fields[iCont].DataType,
                        cdsOriginal.Fields[iCont].Size,
                        False);
        end
        else
        begin
          FieldDefs.Add(cdsOriginal.Fields[iCont].FieldName,
                        cdsOriginal.Fields[iCont].DataType,
                        cdsOriginal.Fields[iCont].Size,
                        cdsOriginal.Fields[iCont].Required);
        end;
      End;

      CreateDataSet;
      Open;

      for iCont := 0 to cdsOriginal.Fields.Count-1 do
      begin
        Fields[iCont].DisplayLabel := cdsOriginal.Fields[iCont].DisplayLabel;
      end;

      if bComDados then
      Begin
        cdsOriginal.First;
        while not cdsOriginal.Eof do
        Begin
          Append;
          For iCont := 0 to cdsOriginal.Fields.Count-1 do
          Begin
            Fields[iCont].Value := cdsOriginal.Fields[iCont].Value
          End;
          Post;
          cdsOriginal.Next;
        End;
      End;
    End;

  Except on E: Exception do
    Begin
      Abort;
    End;
  End;

End;

function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;

function InputQueryQtdeCaracteres(const sNomeJanela, sDescritivo: string;
  var Value: string; iMaxLength: Integer = 0; bEnterOk: Boolean = False): Boolean;
var
  Form: TForm;
  lblQtdeCaracteres, Prompt: TLabel;
  Memo: TMemo;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;

begin
  Result := False;
  Form := TForm.Create(Application);
  with Form do
    try
      Canvas.Font := Font;
      DialogUnits := GetAveCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption := sNomeJanela;
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
      Position := poScreenCenter;
      Prompt := TLabel.Create(Form);
      with Prompt do
      begin
        Parent := Form;
        Caption := sDescritivo;
        Left := MulDiv(8, DialogUnits.X, 4);
        Top := MulDiv(8, DialogUnits.Y, 8);
        Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
        WordWrap := True;
      end;

      Memo := TMemo.Create(Form);
      with Memo do
      begin
        Parent := Form;
        Left := Prompt.Left;
        Top := Prompt.Top + Prompt.Height + 5;
        Width := MulDiv(164, DialogUnits.X, 4);
        MaxLength := iMaxLength;
        Height := 90;
        Lines.Text := Value;
        SelectAll;

        OnChange   := EvHandler.Change;
        if bEnterOk then
          OnKeyPress := EvHandler.KeyPress2
        Else
          OnKeyPress := EvHandler.KeyPress;

      end;

      lblQtdeCaracteres := TLabel.Create(Form);
      with lblQtdeCaracteres do
      begin
        Parent := Form;
        Name := 'lblQtdeCaracteres';
        Caption := 'Caracteres: '+IntToStr(Length(Trim(Memo.Lines.Text)));
        Left := MulDiv(8, DialogUnits.X, 4);
        Top := Memo.Top + Memo.Height + 5;
        Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
        WordWrap := False;
      end;

      ButtonTop := lblQtdeCaracteres.Top + lblQtdeCaracteres.Height + 15;
      ButtonWidth := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TButton.Create(Form) do
      begin
        Name := 'btnAdicionar';
        Parent := Form;
        Caption := 'Adicionar';
        ModalResult := mrOk;
        Default := True;
        SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth, ButtonHeight);
      end;
      with TButton.Create(Form) do
      begin
        Name := 'btnCancelar';
        Parent := Form;
        Caption := 'Cancelar';
        ModalResult := mrCancel;
        Cancel := True;
        SetBounds(MulDiv(92, DialogUnits.X, 4), ButtonTop, ButtonWidth, ButtonHeight);
        Form.ClientHeight := Top + Height + 13;
      end;
      if ShowModal = mrOk then
      begin
        Value := Memo.Lines.Text;
        Result := True;
      end;
    finally
      Form.Free;
    end;
end;

function InputQueryPersonalizado(const ACaption, APrompt: string; var Value: String; sTipo: Char; out bOcorreuErroValidacao: Boolean;  bPassword : Boolean = False): Boolean;
var
  Form: TForm;
  ddata: TDate;
  Prompt: TLabel;
  MaskEdit: TMaskEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;

  function GetAveCharSize(Canvas: TCanvas): TPoint;
  var
    I: Integer;
    Buffer: array[0..51] of Char;
  begin
    for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
    for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
      GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
    Result.X := Result.X div 52;
  end;

  begin
    Result := False;
    Form := TForm.Create(Application);
    with Form do
    begin
      try
        Canvas.Font := Font;
        DialogUnits := GetAveCharSize(Canvas);
        BorderStyle := bsDialog;
        Caption := ACaption;
        ClientWidth := MulDiv(180, DialogUnits.X, 4);
        Position := poScreenCenter;
        Prompt := TLabel.Create(Form);
        with Prompt do
        begin
          Parent := Form;
          Caption := APrompt;
          Left := MulDiv(8, DialogUnits.X, 4);
          Top := MulDiv(8, DialogUnits.Y, 8);
          Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
          WordWrap := True;
        end;
        MaskEdit := TMaskEdit.Create(Form);
        with MaskEdit do
        begin
          Parent := Form;
          Left := Prompt.Left;
          Top := Prompt.Top + Prompt.Height + 5;
          Width := MulDiv(164, DialogUnits.X, 4);
          MaxLength := 255;
          if sTipo = 'D' then // DATA
            EditMask := '!99/99/0000;1;_';
          if sTipo = 'H' then // HORA
            EditMask := '!99:99;1;_';
          Text := Value;
          SelectAll;
          if bPassword then
            PasswordChar := '*'
          Else
            PasswordChar := #0;
        end;
        ButtonTop := MaskEdit.Top + MaskEdit.Height + 15;
        ButtonWidth := MulDiv(50, DialogUnits.X, 4);
        ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
        with TButton.Create(Form) do
        begin
          Parent := Form;
          Caption := 'OK';
          ModalResult := mrOk;
          Default := True;
          SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
        end;
        with TButton.Create(Form) do
        begin
          Parent := Form;
          Caption := 'Cancelar';
          ModalResult := mrCancel;
          Cancel := True;
          SetBounds(MulDiv(92, DialogUnits.X, 4), MaskEdit.Top + MaskEdit.Height + 15,
          ButtonWidth, ButtonHeight);
          Form.ClientHeight := Top + Height + 13;
        end;
        if ShowModal = mrOk then
        begin
          if sTipo = 'D' then // DATA
          begin
            try
              StrToDate(MaskEdit.Text);
              bOcorreuErroValidacao := False;
            except
              On E: Exception do
              begin
                bOcorreuErroValidacao:= True;
              end;
            end
          end;
          if sTipo = 'H' then  // VALIDACAO DA HORA
          begin
            try
              StrToTime(MaskEdit.Text);
              bOcorreuErroValidacao := False;
            except
              On E: Exception do
              begin
                bOcorreuErroValidacao:= True;
              end;
            end;
          end;
          
          Value := MaskEdit.Text;
          Result := True;
        end;
      finally
        Form.Free;
      end;
    end;
end;

Function RetornaLiberacao (sUsuario, sModulo, sRotina : String): Boolean;
Var vRetorno : Variant;
Begin
  Result := False;
  vRetorno := RetornaCampoBanco('select U.ACEUSUROT           ' +
                                '  from TRUSUROT U            ' +
                                ' WHERE U.CODMODULO = '+sModulo +
                                '   AND U.LOGUSUARI = '+QuotedStr(uppercase(sUsuario))+
                                '   AND U.CODROTINA = '+QuotedStr(sRotina));
  if vRetorno <> Null then
  Begin
    if vRetorno = 'S' then
    Begin
      Result := True;
    End;
  End;
End;


procedure MensagemErroScript(psSQL : String; psMsgErroExcept : String);
Var
  FrmMensagem : TForm;
  memScript   : TMemo;
  memMensagemErro : TMemo;
  btnSair         : TBitBtn;
begin
  try
    try
      FrmMensagem := TForm.Create(Nil);
      with FrmMensagem do
      begin
        Top         := 100;
        Height      := 600;
        Width       := 1000;
        WindowState := wsNormal;
        Position    := poMainFormCenter;
        Caption     := 'Painel para Controle de Mensagens : ' + Application.Title;
      end;

      memScript := TMemo.Create(FrmMensagem);
      with memScript do
      begin
        Parent := FrmMensagem;
        Align := alTop;
        Height := 370;
        Lines.Text := psSQL;
        SelectAll;
        ScrollBars := ssBoth;
      end;

      memMensagemErro := TMemo.Create(FrmMensagem);
      with memMensagemErro do
      begin
        Parent := FrmMensagem;
        Align := alTop;
        Height := 150;
        Lines.Text := psMsgErroExcept;
        SelectAll;
        ScrollBars := ssBoth;
      end;

      btnSair := TBitBtn.Create(FrmMensagem);
      with btnSair do
      begin
        Parent := FrmMensagem;
        Align := alClient;
        Height := 80;
        Font.Size := 10;
        Font.Color := clNavy;
        Caption := 'Sair';
        ModalResult := mrOk;
      end;

      if (FrmMensagem.ShowModal = mrOk) then
      begin
        FrmMensagem.Close;
      end;
    finally
      FecharDestruirForm(FrmMensagem);
      Application.ProcessMessages;                    
    end;
  except
    On E: Exception do
    begin
    end;
  end;
end;

function FecharProcesso(ExeFileName: string): Integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
      Result := Integer(TerminateProcess(
                        OpenProcess(PROCESS_TERMINATE,
                                    BOOL(0),
                                    FProcessEntry32.th32ProcessID),
                                    0));
     ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;









function FormularioGrid(const sNomeJanela, sDescritivo: string;
  var cds : TClientDataSet; bExpandirDoisCliques : Boolean = False): Boolean;
var
  Form: TForm;
  dbg: TDBGrid;
  DialogUnits: TPoint;
  ds: TDataSource;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
  pnlBotoes : TPanel;
  memo : TMemo;

Begin
  Result := False;
  Form := TForm.Create(Application);
  with Form do
    try
      Canvas.Font := Font;
      DialogUnits := GetAveCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption := sNomeJanela;
      //Objetivo:       Se tiver mais de 5 fields fica um pouco mais extensa a janela
      //Desenvolvedor:  Thiago Costa
      //Data Alteração: 14/05/2015 as 15:36hs
      //Versão:         2015.v04
      ClientWidth := MulDiv(360, DialogUnits.X, ifthen(cds.Fields.Count > 5, 3, 4));
      Position := poScreenCenter;
      ds := TDataSource.Create(Form);
      ds.DataSet := cds;
      dbg := TDBGrid.Create(Form);
      memo := TMemo.Create(Form);
      pnlBotoes := TPanel.Create(Form);

      with pnlBotoes do
      Begin
        name := 'pnlBotoes';
        Parent := Form;
        Caption := '';
        Align := alBottom;
        Height := 40;
      End;

      with dbg do
      begin
        Parent := Form;
        Left := MulDiv(8, DialogUnits.X, 4);
        Top := MulDiv(8, DialogUnits.Y, 8);
        Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
        Align := alClient;
        DataSource := ds;
        BringToFront;
        if bExpandirDoisCliques then
        Begin
          OnDblClick := EvHandler.DblClickExpandir;
        End
        Else
        Begin
          OnDblClick := EvHandler.DblClick;
        End;

      end;

      with Memo do
      Begin
        Name := 'memo';
        Parent := Form;
        align := alClient;
        Visible := bExpandirDoisCliques;
        OnDblClick := EvHandler.onClick;
        ScrollBars := ssBoth;
        SendToBack;
      End;

      ButtonTop := pnlBotoes.Top + 10;
      ButtonWidth := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);

      with TButton.Create(Form) do
      begin
        Name := 'btnAdicionar';
        Parent := pnlBotoes;
        Caption := 'Selecionar';
        ModalResult := mrOk;
        Default := True;
        SetBounds(MulDiv(130, DialogUnits.X, ifthen(cds.Fields.Count > 5, 3, 4)), ButtonTop, ButtonWidth, ButtonHeight);
      end;
      with TButton.Create(Form) do
      begin
        Name := 'btnCancelar';
        Parent := pnlBotoes;
        Caption := 'Cancelar';
        ModalResult := mrCancel;
        Cancel := True;
        SetBounds(MulDiv(184, DialogUnits.X, ifthen(cds.Fields.Count > 5, 3, 4)), ButtonTop, ButtonWidth, ButtonHeight);
        pnlBotoes.ClientHeight := Top + Height + 13;
      end;
      if ShowModal = mrOk then
      begin
        Result := True;
      end;
    finally
      Form.Free;
    end;
end;

function GetEnvVarValue(const VarName: string): string;
var
  BufSize: Integer;  // buffer size required for value
begin
  // Get required buffer size (inc. terminal #0)
  BufSize := GetEnvironmentVariable(PChar(VarName), nil, 0);
  if BufSize > 0 then
  begin
    // Read env var value into result string
    SetLength(Result, BufSize - 1);
    GetEnvironmentVariable(PChar(VarName),
      PChar(Result), BufSize);
  end
  else
    // No such environment variable
    Result := '';
end;

procedure CriarAtalho(sCaminhoOrigem, sCaminhoDestino, sDecricaoAtalho, Argumentos : String);
var ShellLink : IShellLink;
    PersistFile : IPersistFile;
    NomeLnk : WideString;
    DirDesktop : String;
    ItemIDList :  PItemIDList;
begin
  if not DirectoryExists(sCaminhoOrigem) then
  Begin
    Exit;
  End;

  ShellLink := CreateComObject(CLSID_ShellLink) as IShellLink;
  PersistFile := ShellLink as IPersistFile;
  with ShellLink do begin
    // Informe o Título do ícone
    SetDescription(PChar(sDecricaoAtalho));
    // Informe o Caminho e o Arquivo
    SetPath(PChar(sCaminhoOrigem));
    // Argumentos para linha de comando, caso existam
    SetArguments(PChar(Argumentos));
    // Informe o Caminho e o Arquivo
    SetWorkingDirectory(PChar(ExtractFilePath(sCaminhoOrigem)));
  end;
 
  // Informe o nome do Atalho
  NomeLnk := sCaminhoDestino+''+ChangeFileExt(sDecricaoAtalho,'.lnk');
  PersistFile.Save(PWideChar(NomeLnk),False);
end;





function ArredondaPorDecimal(valor:Real;casasDecimais:integer):Real;
var
Fator, Fracao: Extended;
begin
  {Eleva o Valor 10 ao expoente mandado na variavel casasDecimais}
  Fator:= IntPower(10, casasDecimais);
  { Multiplica o valor pelo fator e faz a conversao de string e depois para float novamente para evitar arredondamentos. }
  valor:= StrToFloat(FloatToStr(valor* Fator));
  {Pega a Parte Inteira do Numero}
  Result := Int(valor);
  {Pega a Parte Fracionaria}
  Fracao:= Frac(valor);
  {Faz a regra de arredondamento}
  if Fracao >= 0.5 then
      Result := Result + 1
  else if Fracao <= -0.5 then
      Result := Result - 1;
  {O valor Final inteiro divide por 100 para transformar em decimal novamente.}
  Result := Result / Fator;
end;

Procedure ResetAggregates(cds : TClientDataSet);
var
  iColuna : Integer;
Begin
  //Reset dos Aggregates
  With cds do
  Begin
    AggregatesActive := False;
    AutoCalcFields := False;
    For iColuna := 0 to Aggregates.Count-1 do
    Begin
      Aggregates.Items[iColuna].Active := False;
    End;
    For iColuna := 0 to Aggregates.Count-1 do
    Begin
      Aggregates.Items[iColuna].Active := True;
    End;
    AutoCalcFields := True;
    AggregatesActive := True;
  End;
end;

Procedure AtualizarRateio(cdsRateio : TClientDataSet; sOpe, sCodigoLancamentoPrincipal, sCodigoLancamento : String; dValorDocumentoPrincipal, dValorNovoDocumento : Double);
var
  cdsRateioAux : TClientDataSet;
  dValor, dSomaTotal, dDiferenca, dValorDiluido : Double;
  tdsBeforeInsert, tdsBeforePost : TDataSetNotifyEvent;
  sFilter : String;
  Function AtualizarValor(dValorDocumentoPrincipal, dValorNovoDocumento, dValorRateio : Double) : Double;
  var
    dPercentual : Double;
  begin
    Result := 0;
    dPercentual := dValorNovoDocumento / dValorDocumentoPrincipal;
    Result := dValorRateio * dPercentual;
  end;
Begin
  try
    sFilter := '';
    cdsRateioAux := RetornarConsultaCDS('SELECT RCC.*, CAST(0 AS DOUBLE PRECISION) VALOR_RATEIO_ATUALIZADO FROM RATEIO_CENTRO_CUSTO RCC WHERE RCC.CODIGO_LANCAMENTO = '+sCodigoLancamentoPrincipal+
                                        'ORDER BY VALOR_RATEIO');
    if cdsRateioAux.RecordCount <= 0 then
    begin
      if cdsRateio.RecordCount <=0 then
      begin
        Exit;
      end
      else
      begin
        cdsRateio.Filtered := False;
        sFilter := cdsRateio.Filter;
        cdsRateio.Filter := 'CODIGO_LANCAMENTO = ' + sCodigoLancamentoPrincipal;
        cdsRateio.Filtered := True;
        While not cdsRateio.Eof do
        begin
          cdsRateioAux.Append;
          cdsRateioAux.FieldByName('CODIGO_LANCAMENTO').Value := cdsRateio.FieldByName('CODIGO_LANCAMENTO').Value;
          cdsRateioAux.FieldByName('CODEMPRES'        ).Value := cdsRateio.FieldByName('CODEMPRES'        ).Value;
          cdsRateioAux.FieldByName('CODDIVISA'        ).Value := cdsRateio.FieldByName('CODDIVISA'        ).Value;
          cdsRateioAux.FieldByName('CODSUBDIV'        ).Value := cdsRateio.FieldByName('CODSUBDIV'        ).Value;
          cdsRateioAux.FieldByName('CODCENCUS'        ).Value := cdsRateio.FieldByName('CODCENCUS'        ).Value;
          cdsRateioAux.FieldByName('PERCENTUAL_RATEIO').Value := cdsRateio.FieldByName('PERCENTRATEIO'    ).Value;
          cdsRateioAux.FieldByName('VALOR_RATEIO'     ).Value := cdsRateio.FieldByName('VALOR_RATEIO'     ).Value;
          cdsRateioAux.Post;
        end;
        cdsRateio.Filtered := False;
        cdsRateio.Filter := sFilter;
        cdsRateio.Filtered := sFilter <> '';
      end;
    end;

    with cdsRateioAux do
    begin
      First;
      While not Eof do
      begin
        Edit;
        FieldByName('VALOR_RATEIO_ATUALIZADO').AsFloat := ArredondaPorDecimal(AtualizarValor(dValorDocumentoPrincipal, dValorNovoDocumento, FieldByName('VALOR_RATEIO').AsFloat), 2);                                //Valor Total anterior  Valor Total Novo Valor Rateio
        dSomaTotal := dSomaTotal + FieldByName('VALOR_RATEIO_ATUALIZADO').AsFloat;
        Next;
      end;

      dDiferenca := dValorNovoDocumento - dSomaTotal;
      if dDiferenca <> 0 then
      begin
        dValorDiluido := dDiferenca / RecordCount;
        dValorDiluido := ArredondaPorDecimal(dValorDiluido, 2);
        dSomaTotal := 0;
        First;
        While not eof do
        begin
          Edit;
          if RecordCount > RecNo then
          Begin
            FieldByName('VALOR_RATEIO_ATUALIZADO').AsFloat := ArredondaPorDecimal(FieldByName('VALOR_RATEIO_ATUALIZADO').AsFloat, 2) + dValorDiluido;
            dSomaTotal := dSomaTotal + FieldByName('VALOR_RATEIO_ATUALIZADO').AsFloat;
          end
          else
          Begin
    //      Atribui ao ultimo registro o valor necessario para igualar ao total do documento.
            dSomaTotal := dSomaTotal + FieldByName('VALOR_RATEIO_ATUALIZADO').AsFloat;
            dDiferenca := dValorNovoDocumento - dSomaTotal;
            FieldByName('VALOR_RATEIO_ATUALIZADO').AsFloat := ArredondaPorDecimal(FieldByName('VALOR_RATEIO_ATUALIZADO').AsFloat, 2) + ArredondaPorDecimal(dDiferenca, 2);
          end;
          Next;
        end;
      end;
      First;
    end;
    with cdsRateio do
    begin
      if not Active then
      begin
        CreateDataSet;
      end
      else
      begin
        tdsBeforeInsert := cdsRateio.BeforeInsert;
        tdsBeforePost := cdsRateio.BeforePost;
        cdsRateio.BeforeInsert := nil;
        cdsRateio.BeforePost := nil;
      end;
      while not cdsRateioAux.Eof do
      begin
        if Locate('CODIGO_LANCAMENTO;CODDIVISA;CODSUBDIV;CODCENCUS', VarArrayOf([sCodigoLancamento,
                                                                                 cdsRateioAux.FieldByName('CODDIVISA').Value,
                                                                                 cdsRateioAux.FieldByName('CODSUBDIV').Value,
                                                                                 cdsRateioAux.FieldByName('CODCENCUS').Value]), []) then
        begin
          Edit;
        end
        else
        begin
          Append;
        end;
        FieldByName('CODIGO_LANCAMENTO').Value := sCodigoLancamento;
        FieldByName('CODEMPRES'        ).Value := cdsRateioAux.FieldByName('CODEMPRES'              ).Value;
        FieldByName('CODDIVISA'        ).Value := cdsRateioAux.FieldByName('CODDIVISA'              ).Value;
        FieldByName('CODSUBDIV'        ).Value := cdsRateioAux.FieldByName('CODSUBDIV'              ).Value;
        FieldByName('CODCENCUS'        ).Value := cdsRateioAux.FieldByName('CODCENCUS'              ).Value;
        FieldByName('PERCENTRATEIO'    ).Value := cdsRateioAux.FieldByName('PERCENTUAL_RATEIO'      ).Value;
        FieldByName('VALOR_RATEIO'     ).Value := cdsRateioAux.FieldByName('VALOR_RATEIO_ATUALIZADO').Value;
        Post;
        cdsRateioAux.Next;
      end;
    end;
  finally
    cdsRateio.BeforeInsert := tdsBeforeInsert;    
    cdsRateio.BeforePost := tdsBeforePost;
  end;
end;


end.
