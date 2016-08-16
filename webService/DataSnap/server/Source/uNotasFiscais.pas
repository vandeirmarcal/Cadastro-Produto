unit uNotasFiscais;

interface

uses Classes;

type
  TNotaFiscal = class;
  TNotasFiscais = class;

  TNotasFiscais = class(TCollection)
  private
    function GetItem(Index: Integer): TNotaFiscal;
    procedure SetItem(Index: Integer; Value: TNotaFiscal);
  public
    constructor Create(ItemClass: TCollectionItemClass);
    function Add: TNotaFiscal;
    property Items[Index: Integer]: TNotaFiscal read GetItem write SetItem; default;
  end;

  TNotaFiscal = class(TCollectionItem)
  private
    fChave: String;
    fNumero: Integer;
    fNaturezaMercadoria: Integer;
    fEspecieMercadoria: Integer;
    fPesoBruto: Double;
    fPesoCubado: Double;
    fPesoLiquido: Double;
    fCentroCusto: Integer;
    fValorMercadoria: Double;
    fCFOP: Integer;
    fEmissao: TDateTime;
  published
    property Chave: String read fChave write fChave;
    property Numero: Integer read fNumero write fNumero;
    property NaturezaMercadoria: Integer read fNaturezaMercadoria write fNaturezaMercadoria;
    property EspecieMercadoria: Integer read fEspecieMercadoria write fEspecieMercadoria;
    property PesoBruto: Double read fPesoBruto write fPesoBruto;
    property PesoCubado: Double read fPesoCubado write fPesoCubado;
    property PesoLiquido: Double read fPesoLiquido write fPesoLiquido;
    property CentroCusto: Integer read fCentroCusto write fCentroCusto;    
    property ValorMercadoria: Double read fValorMercadoria write fValorMercadoria;
    property CFOP: Integer read fCFOP write fCFOP;
    property Emissao: TDateTime read fEmissao write fEmissao;
  end;

implementation

{ TNotasFiscais }

function TNotasFiscais.Add: TNotaFiscal;
begin
  Result := TNotaFiscal(inherited Add);
end;

constructor TNotasFiscais.Create(ItemClass: TCollectionItemClass);
begin
  inherited Create(ItemClass);
end;

function TNotasFiscais.GetItem(Index: Integer): TNotaFiscal;
begin
  Result := TNotaFiscal(inherited GetItem(Index));
end;

procedure TNotasFiscais.SetItem(Index: Integer; Value: TNotaFiscal);
begin
  inherited SetItem(Index, Value);
end;

end.
