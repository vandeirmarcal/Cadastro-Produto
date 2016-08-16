unit uMunicipio;

interface

type
  TMunicipio = class
  private
    fCodMunicipio: Integer;
    fNomeMunicipio: String;
    fCodIBGE: Integer;
    fUF: String;
  published
    property CodMunicipio: Integer read fCodMunicipio write fCodMunicipio;
    property NomeMunicipio: string read fNomeMunicipio write fNomeMunicipio;
    property CodIBGE: Integer read fCodIBGE write fCodIBGE;
    property UF: String read fUF write fUF;
  end;

implementation

end.


