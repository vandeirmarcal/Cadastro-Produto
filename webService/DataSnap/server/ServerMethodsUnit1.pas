unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth,
     UFuncoes,DB,DBClient,DBXJSON, System.JSON;

type TRegCte = Record
    CNPJEmpresaEmitente       : string;
    CNPJRemetente             : string;
    CNPJDestinatario          : string;
    CNPJExpedidor             : string;
    CNPJRecebedor             : string;
    PagoPor                   : Integer;
    TipoModal                 : integer;
    TipoServico               : integer;
    SituacaoCarga             : integer;
    SituacaoFrete             : integer;
    UFInicioPrestacao         : string;
    IBGECidadeInicioPrestacao : integer;
    UFFimdaPrestacao          : string;
    IBGECidadeFimPrestacao    : integer;
    ResponsavelSeguro         : integer;
  end;

type TRegistroNota = Record
    ChaveAcesso        : string;
    NaturezaMercadoria : integer;
    EspecieMercadoria  : integer;
    ValorMercadoria    : Double;
    NumeroNF           : Integer;
    EmissaoNF          : TDate;
    CFOPNF             : Integer;
    PesoCubado         : Integer;
    Volume             : Double;
    PesoLiquido        : Double;
    PesoBruto          : Double;
    CentroCusto        : Integer;
  end;

type
{$METHODINFO ON}
  TServerMethods1 = class(TComponent)
  private
    { Private declarations }

    { -- ESTRUTURA --
     Cds que carrega as informações do banco
    }
    dados_banco : TDataSet;

    { -- ESTRUTURA --
     Estrutura que guarda as informações do CTE
    }
    cte_reg : TRegCte;

    { -- ESTRUTURA --
     Lista de Notas
    }
    listaNotas : array of TRegistroNota;

    { -- DADOS --
     Lista de Erros CTE
    }
    errosCte : String;

    function validaCampo(tipoDado : integer; nomeCampo, campo : String; var erro : string) : variant;

    {
     Guarda os dados na estrutura CTE

       Parameters :
         cte - Objeto com as informações do CTE

       Return :
         ''     - Dados Salvos com sucesso
         'xxxx' - Erro Campo que esta com problemas
    }
    function guardoDadosCTE(cte : TJSONPair): String;

    {
     Guarda os dados na estrutura CTE

       Parameters :
         nota - Objeto com as informações da Nota

       Return :
         ''     - Dados Salvos com sucesso
         'xxxx' - Erro Campo que esta com problemas
    }
    function guardoDadosNotas(nota : TJSONPair; indice : integer): String;

    {
     Função teste conexão Banco de Dados
    }
    function listaCidadesSonar: String;
  public
    { Public declarations }

    {
     Método responsãvel por emissão de CTE

       Parameters :
         lista_cte : Array de objetos CTE
    }

//    [TValidaUsuario('admin')]
    function emiteCte (lista_cte : TJSONObject): TJSONString;

    function soma:TJSONString;
  end;
{$METHODINFO OFF}

implementation


uses System.StrUtils, uCte;

function TServerMethods1.emiteCte(lista_cte: TJSONObject): TJSONString;

var i : integer;
    erro : string;
    cteSalvar : TCTe;

begin

  Result := TJSONString.Create('');
  erro := '';

  try

    // Percorro minha lista de CTE e Notas
    for i := 0 to lista_cte.Size - 1 do //itera o array para pegar cada elemento
    begin

      // Guardo os dados do CTE
      erro := guardoDadosCTE(lista_cte.Get(i));

      if (erro <> EmptyStr) then
      begin
        break;
      end;
    end;
  finally

    if erro <> EmptyStr then
    begin
      Result := TJSONString.Create(erro);
    end else
    begin

      // Crio objeto CTE
      cteSalvar := TCTe.Create;
      cteSalvar.Emitente.CNPJ     := cte_reg.CNPJEmpresaEmitente;
      cteSalvar.Remetente.CNPJ    := cte_reg.CNPJRemetente;
      cteSalvar.Destinatario.CNPJ := cte_reg.CNPJDestinatario;
      cteSalvar.Expedidor.CNPJ    := cte_reg.CNPJExpedidor;
      cteSalvar.Recebedor.CNPJ    := cte_reg.CNPJRecebedor;
      cteSalvar.PagoPor           := cte_reg.PagoPor;
      cteSalvar.SitCarga          := cte_reg.SituacaoCarga;
      cteSalvar.SitFrete          := cte_reg.SituacaoFrete;
      cteSalvar.Origem.UF         := cte_reg.UFInicioPrestacao;
      cteSalvar.Origem.CodIBGE    := cte_reg.IBGECidadeInicioPrestacao;
      cteSalvar.Destino.UF        := cte_reg.UFFimdaPrestacao;
      cteSalvar.Destino.CodIBGE   := cte_reg.IBGECidadeFimPrestacao;
      cteSalvar.ResponsavelSeguro := cte_reg.ResponsavelSeguro;

      // Percorro e guardo as notas
      for i := 0 to Length(listaNotas) - 1 do
      begin
        cteSalvar.Notas.Add.Chave              := listaNotas[i].ChaveAcesso;
        cteSalvar.Notas.Add.Numero             := listaNotas[i].NumeroNF;
        cteSalvar.Notas.Add.NaturezaMercadoria := listaNotas[i].NaturezaMercadoria;
        cteSalvar.Notas.Add.EspecieMercadoria  := listaNotas[i].EspecieMercadoria;
        cteSalvar.Notas.Add.PesoBruto          := listaNotas[i].PesoBruto;
        cteSalvar.Notas.Add.PesoCubado         := listaNotas[i].PesoCubado;
        cteSalvar.Notas.Add.PesoLiquido        := listaNotas[i].PesoLiquido;
        cteSalvar.Notas.Add.CentroCusto        := listaNotas[i].CentroCusto;
        cteSalvar.Notas.Add.ValorMercadoria    := listaNotas[i].ValorMercadoria;
        cteSalvar.Notas.Add.CFOP               := listaNotas[i].CFOPNF;
        cteSalvar.Notas.Add.Emissao            := listaNotas[i].EmissaoNF;
      end;

      Result := TJSONString.Create('Cte incluído com sucesso!');

      // Destruo objeto
      cteSalvar.Destroy;
    end;
  end;
end;

function TServerMethods1.guardoDadosCTE(cte: TJSONPair): String;

var lista_notas : TJSONArray;
    j,i         : integer;
    nota        : TJSONObject;
    dadoCte     : variant;
    jsonValor   : String;
    erro        : String;

begin

  // Inicializo a variável
  erro := '';
  Result := '';

  // Padrão maiuscula
  jsonValor := UpperCase(cte.JsonString.Value);

  // ----------- ResponsavelSeguro
  //
  if jsonValor = 'RESPONSAVELSEGURO' then
  begin

    dadoCte := validaCampo(1, jsonValor, cte.JsonValue.Value,Result);

    if Result = EmptyStr then
    begin
      cte_reg.ResponsavelSeguro := dadoCte;
    end;

    // Sai
    exit;
  end;

  // ----------- IBGECidadeFimPrestacao
  //
  if jsonValor = 'UFDESTINOIBGE' then
  begin

    dadoCte := validaCampo(1, 'IBGECidadeFimPrestacao', cte.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      cte_reg.IBGECidadeFimPrestacao := dadoCte;
    end;

    // Sai
    exit;
  end;

  // ----------- UFFimdaPrestacao
  //
  if jsonValor = 'UFDESTINO' then
  begin

    dadoCte := validaCampo(0, 'UFFimdaPrestacao', cte.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      cte_reg.UFFimdaPrestacao := dadoCte;
    end;

    // Sai
    exit;
  end;

  // ----------- IBGECidadeInicioPrestacao
  //
  if jsonValor = 'UFORIGEMIBGE' then
  begin

    dadoCte := validaCampo(1, 'IBGECidadeInicioPrestacao', cte.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      cte_reg.IBGECidadeInicioPrestacao := dadoCte;
    end;

    // Sai
    exit;
  end;

  // ----------- UFInicioPrestacao
  //
  if jsonValor = 'UFORIGEM' then
  begin

    dadoCte := validaCampo(0, 'UFInicioPrestacao', cte.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      cte_reg.UFInicioPrestacao := dadoCte;
    end;

    // Sai
    exit;
  end;

  // ----------- SituacaoFrete
  //
  if jsonValor = 'SITUACAOFRETE' then
  begin

    dadoCte := validaCampo(1, 'SituacaoFrete', cte.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      cte_reg.SituacaoFrete := dadoCte;
    end;

    // Sai
    exit;
  end;

  // ----------- SituacaoCarga
  //
  if jsonValor = 'SITUACAOCARGA' then
  begin

    dadoCte := validaCampo(1, 'SituacaoCarga', cte.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      cte_reg.SituacaoCarga := dadoCte;
    end;

    // Sai
    exit;
  end;

  // ----------- TipoServico
  //
  if jsonValor = 'TIPOSERVICO' then
  begin

    dadoCte := validaCampo(1, 'TipoServico', cte.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      cte_reg.TipoServico := dadoCte;
    end;

    // Sai
    exit;
  end;

  // ----------- TipoModal
  //
  if jsonValor = 'TIPOMODAL' then
  begin

    dadoCte := validaCampo(1, 'TipoModal', cte.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      cte_reg.TipoModal := dadoCte;
    end;

    // Sai
    exit;
  end;

  // ----------- PagoPor
  //
  if jsonValor = 'PAGOPOR' then
  begin

    dadoCte := validaCampo(1, 'PagoPor', cte.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      cte_reg.PagoPor := dadoCte;
    end;

    // Sai
    exit;
  end;

  // ----------- CNPJRecebedor
  //
  if jsonValor = 'CNPJRECEBEDOR' then
  begin

    dadoCte := validaCampo(0, 'CNPJRecebedor', cte.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      cte_reg.CNPJRecebedor := dadoCte;
    end;

    // Sai
    exit;
  end;

  // ----------- CNPJExpedidor
  //
  if jsonValor = 'CNPJEXPEDIDOR' then
  begin

    dadoCte := validaCampo(0, 'CNPJExpedidor', cte.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      cte_reg.CNPJExpedidor := dadoCte;
    end;

    // Sai
    exit;
  end;

  // ----------- CNPJDestinatario
  //
  if jsonValor = 'CNPJDESTINATARIO' then
  begin

    dadoCte := validaCampo(0, 'CNPJDestinatario', cte.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      cte_reg.CNPJDestinatario := dadoCte;
    end;

    // Sai
    exit;
  end;

  // ----------- CNPJRemetente
  //
  if jsonValor = 'CNPJREMETENTE' then
  begin

    dadoCte := validaCampo(0, 'CNPJREMETENTE', cte.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      cte_reg.CNPJRemetente := dadoCte;
    end;

    // Sai
    exit;
  end;

  // ----------- CNPJEmpresaEmitente
  //
  if jsonValor = 'CNPJEMPRESAEMITENTE' then
  begin

    dadoCte := validaCampo(0, 'CNPJEMPRESAEMITENTE', cte.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      cte_reg.CNPJEmpresaEmitente := dadoCte;
    end;

    // Sai
    exit;
  end;

  if jsonValor = 'NOTASFISCAIS' then
  begin

    lista_notas := cte.JsonValue as TJSONArray;

    // Percorro minha lista de notas
    for j := 0 to lista_notas.Size - 1 do
    begin

      // Adiciono uma posição
      SetLength(listaNotas, Length(listaNotas)+1);

      // Guardo informação referente a nota
      nota := lista_notas.Get(j) as TJSONObject;

      for i := 0 to nota.Size - 1 do
      begin

        // Guardo as notas
        Result := guardoDadosNotas(nota.Get(i), j);
      end;
    end;
  end;
end;

function TServerMethods1.guardoDadosNotas(nota : TJSONPair; indice : integer): String;

var dadosNota : variant;
    jsonNota : string;

begin

  // Inicilizo a variável
  Result := '';
  jsonNota := UpperCase(nota.JsonString.Value);

  // -------------- CentroCusto
  //
  if jsonNota = 'CENTROCUSTO' then
  begin

    dadosNota := validaCampo(1, 'CentroCusto', nota.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      listaNotas[indice].CentroCusto := dadosNota;
    end;

    // Sai
    exit;
  end;

  // -------------- PesoBruto
  //
  if jsonNota =  'PESOBRUTO' then
  begin

    dadosNota := validaCampo(2, 'PesoBruto', nota.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      listaNotas[indice].PesoBruto := dadosNota;
    end;

    // Sai
    exit;
  end;

  // -------------- PesoLiquido
  //
  if jsonNota =  'PESOLIQUIDO' then
  begin

    dadosNota := validaCampo(2, 'PesoLiquido', nota.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      listaNotas[indice].PesoLiquido := dadosNota;
    end;

    // Sai
    exit;
  end;

  // -------------- Volume
  //
  if jsonNota =  'VOLUME' then
  begin

    dadosNota := validaCampo(2, 'Volume', nota.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      listaNotas[indice].Volume := dadosNota;
    end;

    // Sai
    exit;
  end;

  // -------------- PesoCubado
  //
  if jsonNota =  'PESOCUBADO' then
  begin

    dadosNota := validaCampo(1, 'PesoCubado', nota.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      listaNotas[indice].PesoCubado := dadosNota;
    end;

    // Sai
    exit;
  end;

  // -------------- CFOPNF
  //
  if jsonNota =  'CFOP' then
  begin

    dadosNota := validaCampo(1, 'CFOPNF', nota.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      listaNotas[indice].CFOPNF := dadosNota;
    end;

    // Sai
    exit;
  end;

  // -------------- EmissaoNF
  //
  if jsonNota =  'EMISSAO' then
  begin

    dadosNota := validaCampo(3, 'EmissaoNF', nota.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      listaNotas[indice].EmissaoNF := dadosNota;
    end;

    // Sai
    exit;
  end;

  // -------------- NumeroNF
  //
  if jsonNota =  'NUMERO' then
  begin

    dadosNota := validaCampo(1, 'NumeroNF', nota.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      listaNotas[indice].NumeroNF := dadosNota;
    end;

    // Sai
    exit;
  end;

  // -------------- ValorMercadoria
  //
  if jsonNota =  'VALORMERCADORIA' then
  begin

    dadosNota := validaCampo(2, 'ValorMercadoria', nota.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      listaNotas[indice].ValorMercadoria := dadosNota;
    end;

    // Sai
    exit;
  end;

  // -------------- EspecieMercadoria
  //
  if jsonNota =  'ESPECIEMERCADORIA' then
  begin

    dadosNota := validaCampo(1, 'EspecieMercadoria', nota.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      listaNotas[indice].EspecieMercadoria := dadosNota;
    end;

    // Sai
    exit;
  end;

  // -------------- NaturezaMercadoria
  //
  if jsonNota =  'NATUREZAMERCADORIA' then
  begin

    dadosNota := validaCampo(1, 'NaturezaMercadoria', nota.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      listaNotas[indice].NaturezaMercadoria := dadosNota;
    end;

    // Sai
    exit;
  end;

  // -------------- ChaveAcesso
  //
  if jsonNota =  'CHAVEACESSO' then
  begin

    dadosNota := validaCampo(0, 'ChaveAcesso', nota.JsonValue.Value, Result);

    if Result = EmptyStr then
    begin
      listaNotas[indice].ChaveAcesso := dadosNota;
    end;

    // Sai
    exit;
  end;
end;


function TServerMethods1.listaCidadesSonar: String;

var cidade : string;
begin

  dados_banco := RetornarConsultaCDS('SELECT CS.nome FROM cidade_sonar CS');

  dados_banco.First;
  while not(dados_banco.Eof) do
  begin
    cidade := cidade +','+dados_banco.FieldByName('NOME').AsString;

    dados_banco.Next;
  end;
  Result := cidade;
end;

function TServerMethods1.soma: TJSONString;

var nota : TJSONString;

begin
  nota := TJSONString.Create('teste');
  Result := nota;
end;

function TServerMethods1.validaCampo(tipoDado : integer; nomeCampo, campo : String; var erro : string) : variant;

  var vlrInteiro : Integer;
      vlrFloat   : Double;
      vlrData    : TDateTime;

begin

  // Inicializo as variáveis
  vlrInteiro := -1;
  vlrFloat   := -1;
  vlrData    := -1;

  case tipoDado of

    // String
    0 :
    begin

      Result := '';
      erro   := '';

      if campo = '' then
      begin
        erro := nomeCampo+' não pode ter valor vazio ';
        errosCte := ' '+errosCte+' campo '+erro;
      end else
      begin
        Result := campo;
      end;
    end;

    // Integer
    1 :
    begin

      Result := -1;

      if not TryStrToInt(campo, vlrInteiro) then
      begin
        erro := nomeCampo+' não é um valor inteiro valido';
        errosCte := errosCte+' campo '+erro;
      end else
      begin
        Result := vlrInteiro;
      end;
    end;

    // Double
    2 :
    begin

      Result := -1;

      if not TryStrToFloat(campo, vlrFloat) then
      begin
        erro := nomeCampo+' não é um valor Float valido';
        errosCte := errosCte+' campo '+erro;
      end else
      begin
        Result := vlrFloat;
      end;
    end;

    3 :
    begin

      Result := -1;

      if not TryStrToDate(campo, vlrData) then
      begin
        erro := nomeCampo+' não é um data valida';
        errosCte := errosCte+' campo '+erro;
      end else
      begin
        Result := vlrData;
      end;
    end;
  end;
end;

end.

