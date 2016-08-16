unit uEndereco;

interface

uses uMunicipio;

type
  TEndereco = class
  private
    fLogradouro: String;
    fNumero: Integer;
    fBairro: String;
    fComplemento: String;
    fCEP: String;
    fMunicipio: TMunicipio;
    fCodPais: Integer;
    fNomePais: String;
  public
    constructor Create;
  published
    property Logradouro: String read fLogradouro write fLogradouro;
    property Numero: Integer read fNumero write fNumero;
    property Bairro: String read fBairro write fBairro;
    property Complemente: String read fComplemento write fComplemento;
    property CEP: String read fCEP write fCEP;
    property MUnicipio: TMunicipio read fMunicipio write fMunicipio;
    property CodPais: Integer read fCodPais write fCodPais;
    property NomePais: string read fNomePais write fNomePais;
  end;

implementation

{ TEndereco }

constructor TEndereco.Create;
begin
  fMunicipio := TMunicipio.Create;
end;

end.
