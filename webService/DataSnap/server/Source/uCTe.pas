unit uCTe;

interface

uses
  SysUtils, uEndereco, uRemetente, uDestinatario, uTomador, uTipoModal, uMunicipio, uExpedidor, uRecebedor, uEmitente, uNotasFiscais;

type
  TCTe = class
  private
    fChave: String;
    fNumero: Integer;
    fRemetente: TRemetente;
    fDestinatario: TDestinatario;
    fEmitente: TEmitente;
    fTomador: TTomador;
    fExpedidor: TExpedidor;
    fRecebedor: TRecebedor;
    fTipoModal: TTipoModal;
    fOrigem: TMunicipio;
    fDestino: TMunicipio;
    fSitCarga: Integer;
    fSitFrete: Integer;
    fNotas: TNotasFiscais;
    fPagoPor: Integer;
    fResponsavelSeguro: Integer;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Chave: String read fChave write fChave;
    property Numero: Integer read fNumero write fNumero;
    property Remetente: TRemetente read fRemetente write fRemetente;
    property Destinatario: TDestinatario read fDestinatario write fDestinatario;
    property Emitente: TEmitente read fEmitente write fEmitente;
    property Tomador: TTomador read fTomador write fTomador;
    property Expedidor: TExpedidor read fExpedidor write fExpedidor;
    property Recebedor: TRecebedor read fRecebedor write fRecebedor;
    property TipoModal: TTipoModal read fTipoModal write fTipoModal;
    property Origem: TMunicipio read fOrigem write fOrigem;
    property Destino: TMunicipio read fDestino write fDestino;
    property SitCarga: Integer read fSitCarga write fSitCarga;
    property SitFrete: Integer read fSitFrete write fSitFrete;
    property Notas: TNotasFiscais read fNotas write fNotas;
    property PagoPor: Integer read fPagoPor write fPagoPor;
    property ResponsavelSeguro: Integer read fResponsavelSeguro write fResponsavelSeguro;
  end;

implementation

{ TCTe }

constructor TCTe.Create;
begin
  fRemetente := TRemetente.Create();
  fDestinatario := TDestinatario.Create();
  fEmitente := TEmitente.Create();
  fTomador := TTomador.Create();
  fExpedidor := TExpedidor.Create();
  fRecebedor := TRecebedor.Create();
  fOrigem := TMunicipio.Create();
  fDestino := TMunicipio.Create();
  fNotas := TNotasFiscais.Create(TNotaFiscal);
end;

destructor TCTe.Destroy;
begin
  FreeAndNil(fRemetente);
  FreeAndNil(fDestinatario);
  FreeAndNil(fEmitente);
  FreeAndNil(fTomador);
  FreeAndNil(fExpedidor);
  FreeAndNil(fRecebedor);
  FreeAndNil(fTipoModal);
  FreeAndNil(fOrigem);
  FreeAndNil(fDestino);
  FreeAndNil(fNotas);
  inherited;
end;

end.
